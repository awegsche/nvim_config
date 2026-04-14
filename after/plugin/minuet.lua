-- Minuet-ai.nvim configuration with Portkey gateway for Claude
-- Provides copilot-style ghost text completions
--
-- Required environment variables:
--   PORTKEY_API_KEY     - Your Portkey API key
--
-- Optional environment variables:
--   PORTKEY_PROVIDER    - Your Portkey provider slug (defaults to "anthropic")
--   PORTKEY_CONFIG_ID   - Your Portkey config ID for advanced routing
--   ANTHROPIC_API_KEY   - Only needed if NOT using a Portkey virtual key

local ok, minuet = pcall(require, "minuet")
if not ok then
    return
end

-- Get Portkey configuration from environment
local portkey_api_key = os.getenv("PORTKEY_API_KEY") or ""
local portkey_provider = os.getenv("PORTKEY_PROVIDER") or "anthropic"
local portkey_config_id = os.getenv("PORTKEY_CONFIG_ID")

-- Transform function to add Portkey headers to requests
-- Receives: { end_point = string, headers = table, body = table }
-- Returns: modified table
local function add_portkey_headers(data)
    -- Add Portkey authentication header
    data.headers["x-portkey-api-key"] = portkey_api_key

    -- Use config ID if provided, otherwise use provider
    if portkey_config_id then
        data.headers["x-portkey-config"] = portkey_config_id
    else
        data.headers["x-portkey-provider"] = portkey_provider
    end

    return data
end

minuet.setup({
    -- Use Claude provider with Portkey endpoint
    provider = "claude",

    -- Throttle and debounce to control API costs
    throttle = 800, -- Only send request every 1000ms
    debounce = 200,  -- Wait 500ms after typing stops
    request_timeout = 3, -- 3 second timeout

    -- Virtual text (ghost text) configuration
    virtualtext = {
        -- Enable for all filetypes, or specify: { 'lua', 'python', 'rust' }
        auto_trigger_ft = { '*' },
        -- Filetypes to exclude from auto-trigger
        auto_trigger_ignore_ft = { 'TelescopePrompt', 'NvimTree', 'neo-tree' },
        keymap = {
            -- Accept whole completion
            accept = '<Tab>',
            -- Accept one line at a time
            accept_line = '<A-l>',
            -- Accept n lines (prompts for number)
            accept_n_lines = '<A-n>',
            -- Cycle to next completion
            next = '<A-]>',
            -- Cycle to previous completion
            prev = '<A-[>',
            -- Dismiss suggestion
            dismiss = '<C-]>',
        },
        -- Don't show virtual text when cmp menu is visible
        show_on_completion_menu = false,
    },

    -- Claude provider options with Portkey endpoint
    provider_options = {
        claude = {
            -- Use Portkey gateway instead of direct Anthropic API
            end_point = "https://api.portkey.ai/v1/messages",
            -- Use Haiku for fast, cheap completions
            model = "claude-haiku-4-5-20251001",
            -- API key for x-api-key header (Portkey passes this through)
            api_key = "ANTHROPIC_API_KEY",
            -- Max tokens for completion
            max_tokens = 256,
            -- Enable streaming for faster first token
            stream = true,
            -- Transform function to add Portkey headers
            transform = { add_portkey_headers },
            -- Optional parameters
            optional = {
                -- Stop sequences to prevent runaway completions
                -- stop_sequences = { '\n\n' },
            },
        },
    },

    -- Number of completion suggestions to generate
    n_completions = 2,

    -- Context window size (characters, not tokens)
    -- 16000 chars ≈ 4000 tokens
    context_window = 12000,

    -- Ratio of context before vs after cursor (0.75 = 3:1 before:after)
    context_ratio = 0.75,

    -- Add single-line entry for multi-line completions
    add_single_line_entry = true,

    -- Notification level: false, "debug", "verbose", "warn", "error"
    notify = "warn",
})

-- Print a message on startup if API keys are missing
vim.defer_fn(function()
    local pk_key = os.getenv("PORTKEY_API_KEY")
    local anthropic_key = os.getenv("ANTHROPIC_API_KEY")
    local pk_provider = os.getenv("PORTKEY_PROVIDER")
    local config_id = os.getenv("PORTKEY_CONFIG_ID")

    if not pk_key then
        vim.notify("Minuet: PORTKEY_API_KEY not set", vim.log.levels.WARN)
    end

    local has_virtual_key = pk_provider and pk_provider:match("^@")
    if not anthropic_key and not config_id and not has_virtual_key then
        vim.notify(
            "Minuet: Set ANTHROPIC_API_KEY, or use a Portkey virtual key (@...) in PORTKEY_PROVIDER",
            vim.log.levels.WARN
        )
    end
end, 1500)
