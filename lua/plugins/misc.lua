-- Standalone plugins with less than 50 lines of config go here
return {
  {
    -- Hints keybinds
    'folke/which-key.nvim',
  },
  {
    -- Autoclose parentheses, brackets, quotes, etc.
    'echasnovski/mini.pairs',
    config = function()
      require('mini.pairs').setup()
    end,
    opts = {},
  },
  {
    -- Highlight todo, notes, etc in comments
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = true },
  },
  {
    -- High-performance color highlighter
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end,
  },
  {
    -- Session's Auto-saving & write
    'echasnovski/mini.sessions',
    version = false,
    config = function()
      require('mini.sessions').setup {
        autoread = true,
        autowrite = true,
      }
    end,
  },
}
