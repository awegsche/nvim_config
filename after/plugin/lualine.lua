local lualine = require('lualine')

-- ── LSP progress spinner ──────────────────────────────────────────────────────
local spinner_frames = { '⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷' }
local lsp_progress_msg = ''
local lsp_spinner_timer = nil

local function start_spinner_timer()
  if lsp_spinner_timer then return end
  lsp_spinner_timer = vim.uv.new_timer()
  lsp_spinner_timer:start(0, 120, vim.schedule_wrap(function()
    if lsp_progress_msg == '' then
      lsp_spinner_timer:stop()
      lsp_spinner_timer:close()
      lsp_spinner_timer = nil
    else
      vim.cmd.redrawstatus()
    end
  end))
end

vim.api.nvim_create_autocmd('LspProgress', {
  callback = function(ev)
    local val = ev.data.params.value
    if val.kind == 'end' then
      lsp_progress_msg = ''
    else
      local msg = val.title or ''
      if val.message   then msg = msg .. ': ' .. val.message end
      if val.percentage then msg = msg .. ' (' .. val.percentage .. '%)' end
      lsp_progress_msg = msg
      start_spinner_timer()
    end
    vim.cmd.redrawstatus()
  end,
})

local function lsp_progress()
  if lsp_progress_msg == '' then return '' end
  local ms    = math.floor(vim.uv.hrtime() / 1e6)
  local frame = math.floor(ms / 120) % #spinner_frames
  return spinner_frames[frame + 1] .. ' ' .. lsp_progress_msg
end

-- ── LSP client name ───────────────────────────────────────────────────────────
local function lsp_client_name()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then return '' end
  local names = {}
  for _, c in ipairs(clients) do
    if c.name ~= 'null-ls' and c.name ~= 'none-ls' then
      table.insert(names, c.name)
    end
  end
  return #names > 0 and ('󰒍 ' .. table.concat(names, ', ')) or ''
end

-- ── Python venv ───────────────────────────────────────────────────────────────
local function python_venv()
  if vim.bo.filetype ~= 'python' then return '' end
  local venv = vim.env.VIRTUAL_ENV or vim.env.CONDA_DEFAULT_ENV
  if not venv then return '' end
  return ' ' .. vim.fn.fnamemodify(venv, ':t')
end

-- ── Theme: auto-tracks catppuccin flavor (latte/mocha/etc.), falls back to 'auto'
local function get_theme()
  local name = vim.g.colors_name or ''
  local ok = pcall(require, 'lualine.themes.' .. name)
  return ok and name or 'auto'
end

-- ── Setup ─────────────────────────────────────────────────────────────────────
lualine.setup({
  options = {
    theme                = get_theme(),
    section_separators   = { left = '', right = '' },
    component_separators = { left = '', right = '' },
    globalstatus         = true,
  },

  sections = {
    lualine_a = {
      {
        'mode',
        fmt = function(str)
          local map = {
            NORMAL = 'NRM', VISUAL = 'VIS', ['V-LINE'] = 'VIL', ['V-BLOCK'] = 'VIB',
            INSERT = 'INS', REPLACE = 'RPL', COMMAND = 'CMD', TERMINAL = 'TRM',
          }
          return map[str] or str:sub(1, 3)
        end,
      },
    },
    lualine_b = {
      { 'branch', icon = '' },
      {
        'diff',
        symbols = { added = ' ', modified = ' ', removed = ' ' },
      },
    },
    lualine_c = {
      {
        'filename',
        path    = 1, -- relative path
        symbols = { modified = '●', readonly = '', unnamed = '[No Name]' },
      },
      {
        'diagnostics',
        sources          = { 'nvim_diagnostic' },
        symbols          = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
        update_in_insert = false,
      },
      { lsp_progress },
    },
    lualine_x = {
      { python_venv },
      { 'searchcount', maxcount = 999 },
      { lsp_client_name },
      {
        'encoding',
        cond = function() return vim.fn.winwidth(0) > 80 end,
      },
      {
        'fileformat',
        symbols = { unix = 'LF', dos = 'CRLF', mac = 'CR' },
      },
    },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },

  inactive_sections = {
    lualine_c = { { 'filename', path = 1 } },
    lualine_x = { 'location' },
  },
})
