-- lua/kickstart/plugins/undo-tree.lua

-- 1. Add the plugin
local gh = function(repo) return 'https://github.com/' .. repo end
vim.pack.add { gh 'mbbill/undotree' }

-- 2. Configuration (Vim globals)
-- We set these before the toggle to ensure the UI behaves as expected
vim.g.undotree_DiffAutoOpen = 0

-- 3. Keymaps
vim.keymap.set('n', '<leader>uu', vim.cmd.UndotreeToggle, { desc = 'Toggle Undotree' })
