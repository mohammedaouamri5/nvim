return {
  'mbbill/undotree',
  config = function()
    vim.keymap.set('n', '<leader>uu', vim.cmd.UndotreeToggle)
    vim.g.undotree_DiffAutoOpen = 0
  end,
}
