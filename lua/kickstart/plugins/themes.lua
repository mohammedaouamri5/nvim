-- lua/kickstart/plugins/themes.lua

local gh = function(repo) return 'https://github.com/' .. repo end

-- 1. Add the heavy hitters
vim.pack.add {
  gh 'tanvirtin/monokai.nvim', -- High quality Monokai
  gh 'Mofiqul/dracula.nvim', -- Official Dracula port
  gh 'ellisonleao/gruvbox.nvim', -- Modern Gruvbox
  gh 'EdenEast/nightfox.nvim', -- Includes 'carbonfox' (extra dark/black)
}

-- 2. Configuration for your favorite: Monokai
require('monokai').setup {
  palette = require('monokai').pro, -- Use the 'Pro' version you like
}

-- 3. Configuration for the "Extra Dark" option (Carbonfox)
require('nightfox').setup {
  options = {
    transparent = false, -- Set to true if you want it even darker (using terminal bg)
    styles = {
      comments = 'italic',
    },
  },
}

-- 4. Set the default theme
-- Since you prefer Monokai:
vim.cmd.colorscheme 'monokai'

-- Note: To try the extra dark one, run: :colorscheme carbonfox
-- Note: To try Dracula, run: :colorscheme dracula
-- Note: To try Gruvbox, run: :colorscheme gruvbox
