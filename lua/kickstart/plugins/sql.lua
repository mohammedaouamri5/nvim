-- lua/kickstart/plugins/sql.lua

local gh = function(repo) return 'https://github.com/' .. repo end

-- 1. Add the plugins to the runtime path
-- Note: Dependencies must be added explicitly in vim.pack
vim.pack.add {
  gh 'tpope/vim-dadbod',
  gh 'kristijanhusak/vim-dadbod-ui',
  gh 'kristijanhusak/vim-dadbod-completion',
}

-- 2. Configuration (Formerly the 'init' function)
vim.g.db_ui_use_nerd_fonts = 1

-- 3. Lazy-load Completion for SQL files
-- This mimics: ft = { 'sql', 'mysql', 'plsql' }
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'sql', 'mysql', 'plsql' },
  callback = function()
    -- This ensures the completion source is registered only for database files
    require('cmp').setup.buffer {
      sources = { { name = 'vim-dadbod-completion' } },
    }
  end,
})
