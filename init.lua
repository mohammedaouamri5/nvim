--[[
=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================
========                                    .-----.          ========
========         .----------------------.   | === |          ========
========         |.-""""""""""""""""""-.|   |-----|          ========
========         ||                    ||   | === |          ========
========         ||   KICKSTART.NVIM   ||   |-----|          ========
========         ||                    ||   | === |          ========
========         ||                    ||   |-----|          ========
========         ||:Tutor              ||   |:::::|          ========
========         |'-..................-'|   |____o|          ========
========         `"")----------------(""`   ___________      ========
========        /::::::::::|  |::::::::::\  \ no mouse \     ========
========       /:::========|  |==hjkl==:::\  \ required \    ========
========      '""""""""""""'  '""""""""""""'  '""""""""""'   ========
========                                                     ========
=====================================================================
=====================================================================
--]]

-- ============================================================
-- SECTION 1: FOUNDATION
-- Core Neovim settings, leaders, options, basic keymaps, basic autocmds
-- ============================================================
do
  vim.loader.enable()

  vim.g.mapleader = ' '
  vim.g.maplocalleader = ' '

  -- Set to true if you have a Nerd Font installed and selected in the terminal
  vim.g.have_nerd_font = true

  -- [[ Setting options ]]
  vim.o.number = true
  vim.o.relativenumber = true
  vim.o.mouse = 'a'
  vim.o.showmode = false
  vim.o.confirm = true
  vim.o.swapfile = false

  -- Sync clipboard between OS and Neovim.
  vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

  vim.o.breakindent = true
  vim.o.undofile = true
  vim.o.ignorecase = true
  vim.o.smartcase = true
  vim.o.signcolumn = 'yes'
  vim.o.updatetime = 250
  vim.o.timeoutlen = 300
  vim.o.splitright = true
  vim.o.splitbelow = true
  vim.o.list = true
  vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
  vim.o.inccommand = 'split'
  vim.o.cursorline = true
  vim.o.scrolloff = 10

  -- Tab / indent settings
  vim.o.expandtab = true
  vim.o.tabstop = 4
  vim.o.softtabstop = 4
  vim.o.shiftwidth = 4

  -- [[ Basic Keymaps ]]

  -- Clear highlights on search when pressing <Esc> in normal mode
  vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

  -- Diagnostic config
  vim.diagnostic.config {
    update_in_insert = false,
    severity_sort = true,
    float = { border = 'rounded', source = 'if_many' },
    underline = { severity = { min = vim.diagnostic.severity.WARN } },
    virtual_text = true,
    virtual_lines = false,
    jump = {
      on_jump = function(_, bufnr)
        vim.diagnostic.open_float {
          bufnr = bufnr,
          scope = 'cursor',
          focus = false,
        }
      end,
    },
  }

  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

  -- Exit terminal mode
  vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

  -- Split navigation
  vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
  vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
  vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
  vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

  -- Yank with motion prompt
  vim.keymap.set('n', 'cy', function()
    local motion = vim.fn.input 'Enter motion: '
    vim.cmd('normal! v' .. motion .. 'y')
  end, { desc = 'Yank with motion' })

  -- System clipboard shortcuts
  vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y', { noremap = true, silent = true })
  vim.keymap.set({ 'n', 'v' }, '<leader>p', '"+p', { noremap = true, silent = true })

  -- Paste in visual mode without yanking the replaced text
  vim.keymap.set('v', 'p', '"_dP', { noremap = true, silent = true })

  -- Format document (full LSP format)
  vim.keymap.set({ 'n', 'v' }, '<leader>i', function() vim.lsp.buf.format { async = false, timeout_ms = 5000 } end, { desc = 'Format Document' })

  -- REST client
  vim.keymap.set('n', '<C-M-CR>', '<cmd>:Rest run<CR>')
  vim.keymap.set('n', '<C-M-BS>', '<cmd>:q<CR>')

  -- Toggle markdown checkbox
  vim.keymap.set('n', '<leader>tc', function() require('markdown-togglecheck').toggle() end, { desc = 'Toggle Markdown Checkbox' })

  -- [[ Basic Autocommands ]]

  -- Highlight when yanking
  vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function() vim.hl.on_yank() end,
  })

  -- Auto-save on leaving insert mode
  vim.api.nvim_create_autocmd('InsertLeave', {
    desc = 'auto-save',
    group = vim.api.nvim_create_augroup('auto-save', { clear = true }),
    command = 'silent! wa',
  })

  -- Set fold method per buffer
  vim.api.nvim_create_autocmd('BufEnter', {
    desc = 'folding',
    group = vim.api.nvim_create_augroup('folding', { clear = true }),
    command = 'set foldmethod=indent',
  })
end

-- ============================================================
-- SECTION 2: PLUGIN MANAGER
-- vim.pack setup and build hooks
-- ============================================================
do
  -- `vim.pack` is Neovim's built-in plugin manager (Neovim 0.12+).
  -- To update plugins: :lua vim.pack.update()
  -- To inspect state:  :lua vim.pack.update(nil, { offline = true })

  local function run_build(name, cmd, cwd)
    local result = vim.system(cmd, { cwd = cwd }):wait()
    if result.code ~= 0 then
      local stderr = result.stderr or ''
      local stdout = result.stdout or ''
      local output = stderr ~= '' and stderr or stdout
      if output == '' then output = 'No output from build command.' end
      vim.notify(('Build failed for %s:\n%s'):format(name, output), vim.log.levels.ERROR)
    end
  end

  vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
      local name = ev.data.spec.name
      local kind = ev.data.kind
      if kind ~= 'install' and kind ~= 'update' then return end

      if name == 'telescope-fzf-native.nvim' and vim.fn.executable 'make' == 1 then
        run_build(name, { 'make' }, ev.data.path)
        return
      end

      if name == 'LuaSnip' then
        if vim.fn.has 'win32' ~= 1 and vim.fn.executable 'make' == 1 then run_build(name, { 'make', 'install_jsregexp' }, ev.data.path) end
        return
      end

      if name == 'nvim-treesitter' then
        if not ev.data.active then vim.cmd.packadd 'nvim-treesitter' end
        vim.cmd 'TSUpdate'
        return
      end
    end,
  })
end

---@param repo string
---@return string
local function gh(repo) return 'https://github.com/' .. repo end

-- ============================================================
-- SECTION 3: UI / CORE UX PLUGINS
-- ============================================================
do
  -- Auto-detect indentation
  vim.pack.add { gh 'NMAC427/guess-indent.nvim' }
  require('guess-indent').setup {}

  -- Nerd Font icons
  if vim.g.have_nerd_font then vim.pack.add { gh 'nvim-tree/nvim-web-devicons' } end

  -- Git signs in the gutter
  vim.pack.add { gh 'lewis6991/gitsigns.nvim' }
  require('gitsigns').setup {
    signs = {
      add = { text = '+' }, ---@diagnostic disable-line: missing-fields
      change = { text = '~' }, ---@diagnostic disable-line: missing-fields
      delete = { text = '_' }, ---@diagnostic disable-line: missing-fields
      topdelete = { text = '‾' }, ---@diagnostic disable-line: missing-fields
      changedelete = { text = '~' }, ---@diagnostic disable-line: missing-fields
    },
  }

  -- Which-key: shows pending keybinds
  vim.pack.add { gh 'folke/which-key.nvim' }
  require('which-key').setup {
    delay = 0,
    icons = { mappings = vim.g.have_nerd_font },
    spec = {
      { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
      { '<leader>t', group = '[T]oggle' },
      { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      { 'gr', group = 'LSP Actions', mode = { 'n' } },
    },
  }

  -- Colorscheme: tokyonight as the default fallback.
  -- Your persisted choice from telescope-themes will be applied at the end
  -- of this file via `require 'colorscheme'`.
  vim.pack.add { gh 'folke/tokyonight.nvim' }
  ---@diagnostic disable-next-line: missing-fields
  require('tokyonight').setup {
    styles = { comments = { italic = false } },
  }
  vim.cmd.colorscheme 'tokyonight-night'

  -- Highlight todo/fixme/note comments
  vim.pack.add { gh 'folke/todo-comments.nvim' }
  require('todo-comments').setup { signs = false }

  -- lspkind: VS Code-style pictograms for completion items
  vim.pack.add { gh 'onsails/lspkind.nvim' }
  require('lspkind').init {
    mode = 'symbol_text',
    preset = 'codicons',
    symbol_map = {
      Text = '󰉿 ',
      Method = '󰆧 ',
      Function = '󰘧 ',
      Constructor = ' ',
      Field = '  ',
      Variable = '  ',
      Class = '  ',
      Interface = '  ',
      Module = '  ',
      Property = '  ',
      Unit = '  ',
      Value = '  ',
      Enum = '  ',
      Keyword = '  ',
      Snippet = '  ',
      Color = '  ',
      File = '  ',
      Reference = '  ',
      Folder = '  ',
      EnumMember = '  ',
      Constant = '  ',
      Struct = '  ',
      Event = '  ',
      Operator = '  ',
      TypeParameter = '  ',
    },
  }

  -- mini.nvim collection
  vim.pack.add { gh 'nvim-mini/mini.nvim' }

  -- Better Around/Inside textobjects
  -- NOTE: aa/ii avoids conflict with Neovim 0.12 built-in treesitter selection
  require('mini.ai').setup {
    mappings = {
      around_next = 'aa',
      inside_next = 'ii',
    },
    n_lines = 500,
  }

  -- Surround motions (saiw), sd', sr)' etc.)
  require('mini.surround').setup()

  -- Statusline
  local statusline = require 'mini.statusline'
  statusline.setup { use_icons = vim.g.have_nerd_font }
  ---@diagnostic disable-next-line: duplicate-set-field
  statusline.section_location = function() return '%2l:%-2v' end
end

-- ============================================================
-- SECTION 4: SEARCH & NAVIGATION
-- Telescope + telescope-themes (with persist) + LSP pickers
-- ============================================================
do
  local telescope_plugins = {
    gh 'nvim-lua/plenary.nvim',
    gh 'nvim-telescope/telescope.nvim',
    gh 'nvim-telescope/telescope-ui-select.nvim',
    gh 'andrew-george/telescope-themes', -- your theme switcher with persist
  }
  if vim.fn.executable 'make' == 1 then table.insert(telescope_plugins, gh 'nvim-telescope/telescope-fzf-native.nvim') end
  vim.pack.add(telescope_plugins)

  require('telescope').setup {
    extensions = {
      ['ui-select'] = { require('telescope.themes').get_dropdown() },
      -- Persists your chosen colorscheme to lua/colorscheme.lua
      themes = {
        persist = {
          enabled = true,
          path = vim.fn.stdpath 'config' .. '/lua/colorscheme.lua',
        },
      },
    },
  }

  pcall(require('telescope').load_extension, 'fzf')
  pcall(require('telescope').load_extension, 'ui-select')
  pcall(require('telescope').load_extension, 'themes')

  local builtin = require 'telescope.builtin'
  vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
  vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
  vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
  vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
  vim.keymap.set({ 'n', 'v' }, '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
  vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
  vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
  vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
  vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
  vim.keymap.set('n', '<leader>sc', builtin.commands, { desc = '[S]earch [C]ommands' })
  vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

  vim.keymap.set(
    'n',
    '<leader>/',
    function()
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end,
    { desc = '[/] Fuzzily search in current buffer' }
  )

  vim.keymap.set(
    'n',
    '<leader>s/',
    function() builtin.live_grep { grep_open_files = true, prompt_title = 'Live Grep in Open Files' } end,
    { desc = '[S]earch [/] in Open Files' }
  )

  vim.keymap.set('n', '<leader>sn', function() builtin.find_files { cwd = vim.fn.stdpath 'config' } end, { desc = '[S]earch [N]eovim files' })

  -- LSP pickers via Telescope (wired up on LspAttach)
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('telescope-lsp-attach', { clear = true }),
    callback = function(event)
      local buf = event.buf
      -- Your original bindings
      vim.keymap.set('n', 'gd', builtin.lsp_definitions, { buffer = buf, desc = 'LSP: [G]oto [D]efinition' })
      vim.keymap.set('n', 'gr', builtin.lsp_references, { buffer = buf, desc = 'LSP: [G]oto [R]eferences' })
      vim.keymap.set('n', 'gI', builtin.lsp_implementations, { buffer = buf, desc = 'LSP: [G]oto [I]mplementation' })
      vim.keymap.set('n', '<leader>D', builtin.lsp_type_definitions, { buffer = buf, desc = 'LSP: Type [D]efinition' })
      vim.keymap.set('n', '<leader>ds', builtin.lsp_document_symbols, { buffer = buf, desc = 'LSP: [D]ocument [S]ymbols' })
      vim.keymap.set('n', '<leader>ws', builtin.lsp_dynamic_workspace_symbols, { buffer = buf, desc = 'LSP: [W]orkspace [S]ymbols' })
      -- New kickstart-style bindings (gr* prefix)
      vim.keymap.set('n', 'grr', builtin.lsp_references, { buffer = buf, desc = 'LSP: [G]oto [R]eferences' })
      vim.keymap.set('n', 'gri', builtin.lsp_implementations, { buffer = buf, desc = 'LSP: [G]oto [I]mplementation' })
      vim.keymap.set('n', 'grd', builtin.lsp_definitions, { buffer = buf, desc = 'LSP: [G]oto [D]efinition' })
      vim.keymap.set('n', 'gO', builtin.lsp_document_symbols, { buffer = buf, desc = 'LSP: Open Document Symbols' })
      vim.keymap.set('n', 'gW', builtin.lsp_dynamic_workspace_symbols, { buffer = buf, desc = 'LSP: Open Workspace Symbols' })
      vim.keymap.set('n', 'grt', builtin.lsp_type_definitions, { buffer = buf, desc = 'LSP: [G]oto [T]ype Definition' })
    end,
  })
end

-- ============================================================
-- SECTION 5: LSP
-- Mason, nvim-lspconfig, your servers, LSP keymaps
-- ============================================================
do
  vim.pack.add { gh 'j-hui/fidget.nvim' }
  require('fidget').setup {}

  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
    callback = function(event)
      local map = function(keys, func, desc, mode)
        mode = mode or 'n'
        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
      end

      -- New kickstart bindings
      map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
      map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
      map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
      -- Your original bindings
      map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
      map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
      map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client:supports_method('textDocument/documentHighlight', event.buf) then
        local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.clear_references,
        })
        vim.api.nvim_create_autocmd('LspDetach', {
          group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
          callback = function(event2)
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
          end,
        })
      end

      if client and client:supports_method('textDocument/inlayHint', event.buf) then
        map('<leader>th', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, '[T]oggle Inlay [H]ints')
      end
    end,
  })

  -- Your LSP servers
  ---@type table<string, vim.lsp.Config>
  local servers = {
    clangd = {},
    pyright = {
      settings = {
        python = {
          analysis = {
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
            diagnosticMode = 'openFilesOnly',
            typeCheckingMode = 'off',
          },
        },
      },
    },
    gopls = {
      settings = {
        gopls = {
          completeUnimported = true, -- This is the key setting for auto-imports
          usePlaceholders = true, -- Adds parameter placeholders when completing functions
          analyses = {
            unusedparams = true,
          },
        },
      },
    },
    rust_analyzer = {},
    stylua = {},
    lua_ls = {
      on_init = function(client)
        client.server_capabilities.documentFormattingProvider = false
        if client.workspace_folders then
          local path = client.workspace_folders[1].name
          if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then return end
        end
        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
          runtime = {
            version = 'LuaJIT',
            path = { 'lua/?.lua', 'lua/?/init.lua' },
          },
          workspace = {
            checkThirdParty = false,
            library = vim.tbl_extend('force', vim.api.nvim_get_runtime_file('', true), {
              '${3rd}/luv/library',
              '${3rd}/busted/library',
            }),
          },
        })
      end,
      ---@type lspconfig.settings.lua_ls
      settings = {
        Lua = {
          completion = { callSnippet = 'Replace' },
          format = { enable = false },
        },
      },
    },
  }

  vim.pack.add {
    gh 'neovim/nvim-lspconfig',
    gh 'mason-org/mason.nvim',
    gh 'mason-org/mason-lspconfig.nvim',
    gh 'WhoIsSethDaniel/mason-tool-installer.nvim',
  }

  require('mason').setup {}

  local ensure_installed = vim.tbl_keys(servers or {})
  vim.list_extend(ensure_installed, {
    'arduino_language_server',
    'ts_ls',
  })
  require('mason-tool-installer').setup { ensure_installed = ensure_installed }

  require('mason-lspconfig').setup {
    handlers = {
      function(server_name)
        local server = servers[server_name] or {}
        require('lspconfig')[server_name].setup(server)
      end,
    },
  }
end

-- ============================================================
-- SECTION 6: FORMATTING
-- conform.nvim — your formatters and keymaps
-- ============================================================
do
  vim.pack.add { gh 'stevearc/conform.nvim' }
  require('conform').setup {
    notify_on_error = false,
    format_on_save = function(bufnr)
      -- Disable auto-format for C/C++ (use clangd manually)
      local disable_filetypes = { c = true, cpp = true }
      local lsp_format_opt = disable_filetypes[vim.bo[bufnr].filetype] and 'never' or 'fallback'
      return { timeout_ms = 500, lsp_format = lsp_format_opt }
    end,
    default_format_opts = {
      lsp_format = 'fallback',
    },
    formatters_by_ft = {
      lua = { 'stylua' },
      python = { 'isort', 'black' },
      javascript = { 'prettierd', 'prettier', stop_after_first = true },
    },
  }

  -- <leader>f  — quick async format (new kickstart binding)
  vim.keymap.set({ 'n', 'v' }, '<leader>f', function() require('conform').format { async = true } end, { desc = '[F]ormat buffer' })

  -- <C-S-I> — your original format binding
  vim.keymap.set('', '<C-S-I>', function() require('conform').format { async = true, lsp_format = 'fallback' } end, { desc = '[F]ormat buffer (Ctrl+Shift+I)' })
end

-- ============================================================
-- SECTION 7: AUTOCOMPLETE & SNIPPETS
-- blink.cmp + luasnip + friendly-snippets + dadbod for SQL
-- ============================================================
do
  vim.pack.add { { src = gh 'L3MON4D3/LuaSnip', version = vim.version.range '2.*' } }
  local luasnip = require 'luasnip'
  luasnip.config.setup {}

  -- Load friendly-snippets (VS Code-style snippet collection)
  vim.pack.add { gh 'rafamadriz/friendly-snippets' }
  require('luasnip.loaders.from_vscode').lazy_load()

  vim.pack.add { { src = gh 'saghen/blink.cmp', version = vim.version.range '1.*' } }
  require('blink.cmp').setup {
    keymap = { preset = 'enter' },

    appearance = {
      nerd_font_variant = 'mono',
    },

    completion = {
      documentation = { auto_show = true, auto_show_delay_ms = 500 },
    },

    sources = {
      -- buffer added to default sources (useful for non-LSP files)
      default = { 'lsp', 'path', 'snippets', 'buffer' },

      -- dadbod completion for SQL files
      per_filetype = {
        sql = { 'dadbod', 'buffer' },
      },

      -- Define the provider so blink knows what "dadbod" refers to
      providers = {
        dadbod = {
          name = 'Dadbod',
          module = 'blink.cmp.sources.lib',
        },
      },
    },

    snippets = { preset = 'luasnip' },

    fuzzy = { implementation = 'lua' },

    signature = { enabled = true },
  }
end

-- ============================================================
-- SECTION 8: TREESITTER
-- Modern manual-attach pattern — fixes the old broken TSUpdate setup
-- ============================================================
do
  vim.pack.add { { src = gh 'nvim-treesitter/nvim-treesitter', version = 'main' } }

  -- Core parsers always installed
  local parsers = {
    'bash',
    'c',
    'diff',
    'html',
    'lua',
    'luadoc',
    'markdown',
    'markdown_inline',
    'query',
    'vim',
    'vimdoc',
  }
  require('nvim-treesitter').install(parsers)

  ---@param buf integer
  ---@param language string
  local function treesitter_try_attach(buf, language)
    if not vim.treesitter.language.add(language) then return end
    vim.treesitter.start(buf, language)

    -- Enable treesitter indentation if an indent query exists for this language
    local has_indent_query = vim.treesitter.query.get(language, 'indents') ~= nil
    if has_indent_query then vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end
  end

  local available_parsers = require('nvim-treesitter').get_available()
  vim.api.nvim_create_autocmd('FileType', {
    callback = function(args)
      local buf, filetype = args.buf, args.match
      local language = vim.treesitter.language.get_lang(filetype)
      if not language then return end

      local installed_parsers = require('nvim-treesitter').get_installed 'parsers'

      if vim.tbl_contains(installed_parsers, language) then
        -- Parser already installed — attach immediately
        treesitter_try_attach(buf, language)
      elseif vim.tbl_contains(available_parsers, language) then
        -- Auto-install missing parser, then attach
        require('nvim-treesitter').install(language):await(function() treesitter_try_attach(buf, language) end)
      else
        -- Parser not in nvim-treesitter registry — try anyway (e.g. manually installed)
        treesitter_try_attach(buf, language)
      end
    end,
  })
end

-- ============================================================
-- SECTION 9: YOUR CUSTOM PLUGINS
-- All your kickstart.plugins.* modules (unchanged from your config)
-- ============================================================
do
  -- NOTE: These load files from lua/kickstart/plugins/ in your config directory.
  -- Copy that folder over from your old setup — nothing changes inside those files.
  require 'kickstart.plugins.lsp_signature'
  require 'kickstart.plugins.indent_line'
  require 'kickstart.plugins.lint'
  require 'kickstart.plugins.neo-tree'
  require 'kickstart.plugins.gitsigns'
  require 'kickstart.plugins.lualine'
  require 'kickstart.plugins.auto-save'
  require 'kickstart.plugins.autopairs'
  require 'kickstart.plugins.undo-tree'
  require 'kickstart.plugins.codium'
  require 'kickstart.plugins.sql'
  require 'kickstart.plugins.themes'
  require 'kickstart.plugins.render-markdown'
  -- require 'kickstart.plugins.arduino-nvim'  -- uncomment if needed

  -- Standalone helper module (not a plugin spec)
  require 'kickstart.plugins.switch_chpp'
end

-- ============================================================
-- COLORSCHEME
-- Loaded last so telescope-themes persist (colorscheme.lua) wins
-- ============================================================
require 'colorscheme'

-- vim: ts=2 sts=2 sw=2 et
