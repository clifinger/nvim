return {
    {
        "echasnovski/mini.statusline",
        dependencies = {
            "echasnovski/mini.icons",
            "echasnovski/mini-git",
            "echasnovski/mini.diff",
        },
        version = "*",
        config = function()
            require("mini.statusline").setup()
            require("mini.icons").setup()
            require("mini.git").setup()
            require("mini.diff").setup()
        end,
    },
}
