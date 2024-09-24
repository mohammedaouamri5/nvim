return {
  'fisadev/vim-isort',
  ft = 'python',
  config = function()
    -- Automatically format file buffer when saving

    vim.g.vim_isort_map = '' -- Disable default isort mapping

    vim.api.nvim_create_autocmd({ 'InsertLeave' }, {
      pattern = '*.py',
      callback = function()
        vim.cmd 'Isort'
      end,
    })
  end,
}
