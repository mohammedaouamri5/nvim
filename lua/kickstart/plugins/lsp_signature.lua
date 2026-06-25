-- lua/kickstart/plugins/lsp_signature.lua

-- 1. Add the plugin to the runtime path immediately
local gh = function(repo) return 'https://github.com/' .. repo end
vim.pack.add { gh 'ray-x/lsp_signature.nvim' }

-- 2. Define the configuration table
local cfg = {
  debug = false,
  log_path = vim.fn.stdpath 'cache' .. '/lsp_signature.log',
  verbose = false,
  bind = true, -- Mandatory for border config
  doc_lines = 10,
  max_height = 12,
  wrap = true,
  floating_window = true,
  floating_window_above_cur_line = true,
  floating_window_off_x = 1,
  floating_window_off_y = 0,
  close_timeout = 4000,
  fix_pos = true,
  hint_enable = true,
  hint_prefix = ' ',
  hint_scheme = 'String',
  hint_inline = function() return false end,
  hi_parameter = 'LspSignatureActiveParameter',
  handler_opts = {
    border = 'double',
  },
  always_trigger = true,
  auto_close_after = nil,
  extra_trigger_chars = { '(', ',' },
  zindex = 200,
  padding = ' ',
  transparency = nil,
  shadow_blend = 36,
  shadow_guibg = '#121315',
  timer_interval = 200,
  toggle_key = nil,
  select_signature_key = nil,
  move_signature_window_key = nil,
  move_cursor_key = nil,
}

-- 3. Reproduce the 'InsertEnter' lazy-loading behavior
-- We setup an autocmd that runs once when you enter Insert mode
vim.api.nvim_create_autocmd('InsertEnter', {
  callback = function() require('lsp_signature').setup(cfg) end,
  once = true, -- Ensures setup only runs the first time you enter insert mode
})
