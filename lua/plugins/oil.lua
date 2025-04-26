return {
    "stevearc/oil.nvim",
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
        view_options = {
            show_hidden = true,
        },
        keymaps = {
            ["<C-s>"] = false, -- Disable the default <C-s> mapping for horizontal split
            -- You can disable other conflicting default maps here too if needed
            -- ['<C-h>'] = false, -- Example: Disable horizontal split mapping (if it exists and conflicts)
            -- ['<C-v>'] = false, -- Example: Disable vertical split mapping
            -- ['<C-t>'] = false, -- Example: Disable tab split mapping
        },
    },
    -- Optional dependencies
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
}
