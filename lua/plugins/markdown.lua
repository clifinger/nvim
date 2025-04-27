return {
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    build = function()
      require('lazy').load { plugins = { 'markdown-preview.nvim' } }
      vim.fn['mkdp#util#install']()
    end,
    keys = {
      {
        '<leader>mp',
        ft = 'markdown',
        '<cmd>MarkdownPreviewToggle<cr>',
        desc = 'Markdown Preview',
      },
    },
    config = function()
      vim.cmd [[do FileType]]
    end,
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons', 'folke/snacks.nvim' },
    opts = {
      code = {
        sign = true,
        width = 'block',
        right_pad = 1,
      },
      heading = {
        sign = true,
        icons = {},
      },
      checkbox = {
        enabled = true,
      },
    },
    ft = { 'markdown', 'norg', 'rmd', 'org', 'codecompanion' },
    config = function(_, opts)
      require('render-markdown').setup(opts)
      Snacks.toggle({
        name = 'Render Markdown',
        get = function()
          return require('render-markdown.state').enabled
        end,
        set = function(enabled)
          local m = require 'render-markdown'
          if enabled then
            m.enable()
          else
            m.disable()
          end
        end,
      }):map '<leader>mu'
    end,
  },
}
