return {
  {
    'L3MON4D3/LuaSnip',
    dependencies = { 'rafamadriz/friendly-snippets' },
    version = 'v2.*',
    build = 'make install_jsregexp',
    config = function(_, opts)
      require('luasnip').setup(opts)
      require('luasnip.loaders.from_vscode').lazy_load()
    end,
    opts = {
      history = true,
      delete_check_events = 'TextChanged',
    },
  },
  {
    'rafamadriz/friendly-snippets',
    config = function()
      require('luasnip.loaders.from_vscode').lazy_load()
    end,
  },
  {
    'saghen/blink.compat',
    version = '*',
    lazy = true,
    opts = {},
  },
  {
    'saghen/blink.cmp',
    dependencies = {
      'rafamadriz/friendly-snippets',
      'moyiz/blink-emoji.nvim',
      'ray-x/cmp-sql',
    },

    version = '1.*',

    opts = {
      snippets = {
        preset = 'luasnip',
      },

      keymap = {
        preset = 'enter',
        ['<C-y>'] = { 'select_and_accept' },
      },
      appearance = {
        nerd_font_variant = 'normal',
        use_nvim_cmp_as_default = false,
      },

      completion = {
        documentation = { auto_show = true },
        accept = {
          auto_brackets = { enabled = true },
        },
      },
      signature = { enabled = false },

      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer', 'emoji', 'sql' },

        providers = {
          emoji = {
            module = 'blink-emoji',
            name = 'Emoji',
            score_offset = 15,
            opts = { insert = true },
            should_show_items = function()
              return vim.tbl_contains({ 'gitcommit', 'markdown' }, vim.o.filetype)
            end,
          },
          sql = {
            name = 'sql',
            module = 'blink.compat.source',

            score_offset = -3,

            opts = {},
            should_show_items = function()
              return vim.tbl_contains({ 'sql' }, vim.o.filetype)
            end,
          },
        },
      },

      fuzzy = { implementation = 'prefer_rust_with_warning' },
    },
    opts_extend = { 'sources.default' },
  },
}
