return {
    {
        "JoosepAlviste/nvim-ts-context-commentstring",
        lazy = true,
        opts = {
            enable_autocmd = false
        }
    },
    {
        "echasnovski/mini.comment",
        event = "VeryLazy",
        opts = {
            options = {
                custom_commentstring = function()
                    return require("ts_context_commentstring.internal").calculate_commentstring() or
                           vim.bo.commentstring
                end
            }
        },
        config = function(_, opts)
            require('mini.comment').setup(opts)

            vim.keymap.set('n', '<C-/>', 'gcc', { noremap = true, silent = true, desc = "Toggle comment line" })
            vim.keymap.set('i', '<C-/>', '<Esc>gccA', { noremap = true, silent = true, desc = "Toggle comment line & re-enter Insert" })
            vim.keymap.set('v', '<C-/>', 'gc', { noremap = true, silent = true, desc = "Toggle comment block" })
        end
    }
}
