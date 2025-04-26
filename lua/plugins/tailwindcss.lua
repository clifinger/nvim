-- Tailwindcss config
-- if phoenix project
local function find_tailwind_root_phoenix(fname)
    local util = require("lspconfig.util")
    local phoenix_root = util.root_pattern("mix.exs")(fname)
    if phoenix_root then
        if vim.fn.isdirectory(phoenix_root) == 1 then
            return phoenix_root
        end
    end
    return util.root_pattern("package.json", "tailwind.config.js", "vite.config.js")(fname)
end
return {
    "luckasRanarison/tailwind-tools.nvim",

    dependencies = { "nvim-lspconfig" },
    build = ":UpdateRemotePlugins",
    name = "tailwind-tools",
    opts = {
        server = {
            override = true,
            root_dir = find_tailwind_root_phoenix,
            settings = {},
        },
    },
}
