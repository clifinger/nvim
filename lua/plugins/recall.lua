return {
  'fnune/recall.nvim',
  event = 'VeryLazy',
  opts = {
    snacks = {
      mappings = {
        unmark_selected_entry = {
          normal = 'dd',
          insert = '<C-d>',
        },
      },
    },
  },
  keys = {
    {
      '<leader>mm',
      function()
        require('recall').toggle()
      end,
      desc = 'Recall: Toggle Mark',
    },
    {
      '<leader>mn',
      function()
        require('recall').goto_next()
      end,
      desc = 'Recall: Next Mark',
    },
    {
      '<leader>mp',
      function()
        require('recall').goto_prev()
      end,
      desc = 'Recall: Previous Mark',
    },
    {
      '<leader>mc',
      function()
        require('recall').clear()
      end,
      desc = 'Recall: Clear All Marks',
    },
    {
      '<leader>fm',
      function()
        require('recall.snacks').pick()
      end,
      desc = 'Recall: Find Marks',
    },
  },
  config = function(_, opts)
    require('recall').setup(opts)
  end,
}
