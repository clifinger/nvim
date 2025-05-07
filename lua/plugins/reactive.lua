return {
  'rasulomaroff/reactive.nvim',
  lazy = true,
  event = 'VeryLazy',
  config = function()
    require('reactive').setup {
      builtin = {
        cursorline = true,
        cursor = true,
        modemsg = true,
      },
    }
  end,
}
