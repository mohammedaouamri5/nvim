-- lua/kickstart/plugins/render-markdown.lua

local gh = function(repo) return 'https://github.com/' .. repo end

-- 1. Add the plugin and its dependencies
-- Note: Your init.lua likely already adds treesitter and devicons,
-- but adding them here ensures they are in the runtime path.
vim.pack.add {
  gh 'nvim-treesitter/nvim-treesitter',
  gh 'nvim-tree/nvim-web-devicons',
  gh 'MeanderingProgrammer/render-markdown.nvim',
}

-- 2. Configure the plugin
require('render-markdown').setup {
  -- Enabled for go files to support markdown in code comments
  enabled_filetypes = { 'markdown', 'go' },

  -- Ensures rendering persists across different modes
  render_modes = true,

  anti_conceal = {
    enabled = true, -- Stops icons from disappearing when cursor is on the line
  },

  checkbox = {
    enabled = true,
    unchecked = { icon = '󰄱 ' },
    checked = { icon = '󰄵 ' },
    custom = {
      todo = { raw = '[-]', rendered = '󰥔 ', highlight = 'RenderMarkdownTodo' },
    },
  },

  -- Crucial for rendering markdown inside code comments
  injection = {
    enabled = true,
  },
}
