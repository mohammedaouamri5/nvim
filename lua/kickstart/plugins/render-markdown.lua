return {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    opts = {
        -- Change 'code' to 'go' so the plugin actually attaches to your buffer
        enabled_filetypes = { 'markdown', 'go' },
        -- This ensures the plugin renders even while you're typing or in different modes
        render_modes = true,
        anti_conceal = {
            enabled = true, -- Stops the icons from disappearing when your cursor is on the line
        },

        checkbox = {
            enabled = true,
            unchecked = { icon = '󰄱 ' },
            checked = { icon = '󰄵 ' },
            -- Custom color for the checked box to make it pop
            custom = {
                todo = { raw = '[-]', rendered = '󰥔 ', highlight = 'RenderMarkdownTodo' },
            },
        },
        -- This is the crucial bit for code comments
        injection = {
            enabled = true,
        },
    },
}
