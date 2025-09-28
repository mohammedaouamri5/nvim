return {
  "rest-nvim/rest.nvim",
  dependencies = {
    "nvim-neotest/nvim-nio",
    {
      "j-hui/fidget.nvim",
      opts = {},
    },
    {
      "nvim-treesitter/nvim-treesitter",
      opts = function(_, opts)
        opts.ensure_installed = opts.ensure_installed or {}
        vim.list_extend(opts.ensure_installed, { "http" })
      end,
    },
  },
  config = function()
    require("rest-nvim").setup({
      -- optional defaults
      rocks = {
        hererocks = true, -- use Lua 5.1 toolchain for luarocks deps
      },
      result = {
        split = {
          horizontal = false,
          in_place = false,
          stay_in_split = false,
        },
      },
    })
  end,
}

