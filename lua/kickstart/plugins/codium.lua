-- lua/kickstart/plugins/codium.lua

-- 1. Add the plugin to the pack manager
-- Using the full URL since 'gh' is local to your init.lua
vim.pack.add { 'https://github.com/Exafunction/windsurf.vim' }

-- 2. Configuration and Keymaps
-- Since this plugin uses Vim functions (fn['codeium#...']), we set the maps
-- immediately after adding the package.

-- Accept completion
vim.keymap.set('i', '<C-g>', function() return vim.fn['codeium#Accept']() end, { expr = true, silent = true, desc = 'Codeium Accept' })

-- Cycle forward
vim.keymap.set('i', '<c-;>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true, silent = true, desc = 'Codeium Cycle Next' })

-- Cycle backward
vim.keymap.set('i', '<c-,>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true, silent = true, desc = 'Codeium Cycle Prev' })

-- Clear completion
vim.keymap.set('i', '<c-x>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true, desc = 'Codeium Clear' })
