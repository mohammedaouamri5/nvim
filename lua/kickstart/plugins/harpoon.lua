return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  requires = { { 'nvim-lua/plenary.nvim' } },
  config = function()
    harpoon = require 'harpoon'

    -- REQUIRED
    harpoon:setup()
    -- REQUIRED

    vim.keymap.set('n', '<C-e>', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end)

    vim.keymap.set('n', '<leader>a', function()
      harpoon:list():add()
    end)

    function map(bind, func)
      vim.keymap.set('i', bind, func)
      vim.keymap.set('n', bind, func)
    end

    map('<C-f>', function()
      harpoon:list():select(1)
    end)
    map('<C-d>', function()
      harpoon:list():select(2)
    end)
    map('<C-s>', function()
      harpoon:list():select(3)
    end)
    map('<C-q>', function()
      harpoon:list():select(4)
    end)

    --  harpoon:list():select(4)
    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set('n', '<C-S-P>', function()
      harpoon:list():prev()
    end)
    vim.keymap.set('n', '<C-S-N>', function()
      harpoon:list():next()
    end)

    local global_settings = {
      tabline = true, -- Enable tabline with Harpoon marks
      --    tabline_prefix = '   ', -- Optional: Add a prefix before each tab
      --  tabline_suffix = '   ', -- Optional: Add a suffix after each tab
    }
  end,
}
