return {
  {
    'numToStr/Comment.nvim',
    event = 'VeryLazy',
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
    config = function()
      local opts = { noremap = true, silent = true }
      local pre_hook_func = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()

      require('Comment').setup {
        padding = true,
        sticky = true,
        ignore = nil,
        toggler = {
          line = 'gcc',
          block = 'gbc',
        },
        opleader = {
          line = 'gc',
          block = 'gb',
        },
        extra = {
          above = 'gcO',
          below = 'gco',
          eol = 'gcA',
        },
        mappings = {
          basic = true,
          extra = true,
        },
        pre_hook = pre_hook_func,
        post_hook = nil,
      }
      -- C-/ for commenting, default block mode for VISUAL, you can alway use C-c for line mode in Visual!
      vim.keymap.set('n', '<C-_>', require('Comment.api').toggle.linewise.current, opts)
      vim.keymap.set('n', '<C-c>', require('Comment.api').toggle.linewise.current, opts)
      vim.keymap.set('n', '<C-/>', require('Comment.api').toggle.linewise.current, opts)
      vim.keymap.set('v', '<C-_>', "<esc><cmd>lua require('Comment.api').toggle.blockwise(vim.fn.visualmode())<cr>", opts)
      vim.keymap.set('v', '<C-c>', "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>", opts)
      vim.keymap.set('v', '<C-/>', "<esc><cmd>lua require('Comment.api').toggle.blockwise(vim.fn.visualmode())<cr>", opts)
    end,
  },
}
