-- Avante.nvim configuration with Portkey gateway for Claude
--
-- Required environment variables:
--   PORTKEY_API_KEY     - Your Portkey API key
--
-- Optional environment variables:
--   PORTKEY_PROVIDER    - Your Portkey provider slug (defaults to "anthropic")
--                         Use a virtual key like "@my-anthropic-config" to avoid
--                         needing ANTHROPIC_API_KEY in your shell
--   PORTKEY_CONFIG_ID   - Your Portkey config ID for advanced routing
--   ANTHROPIC_API_KEY   - Only needed if NOT using a Portkey virtual key

local ok, avante = pcall(require, "avante")
if not ok then
    return
end

-- Get Portkey configuration from environment
local portkey_api_key = os.getenv("PORTKEY_API_KEY") or ""
local portkey_provider = os.getenv("PORTKEY_PROVIDER") or "anthropic"
local portkey_config_id = os.getenv("PORTKEY_CONFIG_ID")

-- Build extra headers for Portkey
local function build_portkey_extra_headers()
    local headers = {
        ["x-portkey-api-key"] = portkey_api_key,
    }

    -- Use config ID if provided, otherwise use provider
    if portkey_config_id then
        headers["x-portkey-config"] = portkey_config_id
    else
        headers["x-portkey-provider"] = portkey_provider
    end

    return headers
end

local portkey_headers = build_portkey_extra_headers()

avante.setup({
    -- Use our custom Portkey provider
    provider = "portkey-claude",

    -- Use Haiku for auto-suggestions (faster and cheaper for high-frequency completions)
    auto_suggestions_provider = "portkey-claude-haiku",

    -- Default interaction mode
    mode = "agentic",

    -- Provider configurations
    providers = {
        -- Custom Portkey provider that proxies to Claude Sonnet
        -- Inherits all functionality from Claude, just changes endpoint and adds headers
        -- Using alias (without date) so it auto-updates to latest snapshot
        ["portkey-claude"] = {
            __inherited_from = "claude",
            endpoint = "https://api.portkey.ai",
            model = "claude-sonnet-4-5",
            timeout = 30000,
            -- Use ANTHROPIC_API_KEY for the x-api-key header (inherited from claude)
            -- If using Portkey virtual keys, you can set this to a dummy value
            api_key_name = "ANTHROPIC_API_KEY",
            extra_request_body = {
                temperature = 0.7,
                max_tokens = 8192,
            },
            -- Extra headers get merged into the request by the claude provider
            extra_headers = portkey_headers,
        },

        -- Portkey with Claude Opus (for more complex tasks)
        ["portkey-claude-opus"] = {
            __inherited_from = "claude",
            endpoint = "https://api.portkey.ai",
            model = "claude-opus-4-5",
            timeout = 60000,
            api_key_name = "ANTHROPIC_API_KEY",
            extra_request_body = {
                temperature = 0.7,
                max_tokens = 16384,
            },
            extra_headers = portkey_headers,
        },

        -- Portkey with Claude Haiku (for faster, cheaper responses)
        ["portkey-claude-haiku"] = {
            __inherited_from = "claude",
            endpoint = "https://api.portkey.ai",
            model = "claude-haiku-4-5",
            timeout = 15000,
            api_key_name = "ANTHROPIC_API_KEY",
            extra_request_body = {
                temperature = 0.7,
                max_tokens = 4096,
            },
            extra_headers = portkey_headers,
        },
    },

    -- Behavior settings
    behaviour = {
        auto_suggestions = false,  -- Disabled due to avante.nvim bug (old_line nil error)
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        support_paste_from_clipboard = false,
        minimize_diff = true,
        enable_token_counting = true,
    },

    -- Suggestion throttling (to control API costs)
    suggestion = {
        debounce = 600,   -- Wait 600ms after typing stops before requesting
        throttle = 600,   -- Minimum 600ms between requests
    },

    -- Window settings
    windows = {
        position = "right",
        wrap = true,
        width = 30,
        sidebar_header = {
            enabled = true,
            align = "center",
            rounded = true,
        },
    },

    -- Keymaps
    mappings = {
        diff = {
            ours = "co",
            theirs = "ct",
            all_theirs = "ca",
            both = "cb",
            cursor = "cc",
            next = "]x",
            prev = "[x",
        },
        suggestion = {
            accept = "<Tab>",      -- Accept the suggestion
            next = "<M-]>",        -- Next suggestion (Alt+])
            prev = "<M-[>",        -- Previous suggestion (Alt+[)
            dismiss = "<C-]>",     -- Dismiss suggestion (Ctrl+])
        },
        jump = {
            next = "]]",
            prev = "[[",
        },
        submit = {
            normal = "<CR>",
            insert = "<C-s>",
        },
        sidebar = {
            apply_all = "A",
            apply_cursor = "a",
            switch_windows = "<Tab>",
            reverse_switch_windows = "<S-Tab>",
        },
    },
})

-- Print a message on startup if API keys are missing
vim.defer_fn(function()
    local pk_key = os.getenv("PORTKEY_API_KEY")
    local pk_provider = os.getenv("PORTKEY_PROVIDER")
    local anthropic_key = os.getenv("ANTHROPIC_API_KEY")
    local config_id = os.getenv("PORTKEY_CONFIG_ID")

    if not pk_key then
        vim.notify("Avante: PORTKEY_API_KEY not set", vim.log.levels.WARN)
    end

    -- Warn if no way to authenticate to Anthropic
    -- local has_virtual_key = pk_provider and pk_provider:match("^@")
    -- if not anthropic_key and not config_id and not has_virtual_key then
    --     vim.notify(
    --         "Avante: Set ANTHROPIC_API_KEY, or use a Portkey virtual key (@...) in PORTKEY_PROVIDER",
    --         vim.log.levels.WARN
    --     )
    -- end
end, 1000)
