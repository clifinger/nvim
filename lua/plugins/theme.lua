return {
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    config = function()
      require('rose-pine').setup {
        disable_background = true,
        dark_variant = 'moon',
        disable_italics = false,
        styles = {
          bold = true,
          italic = true,
          transparency = true,
        },
      }
      vim.cmd 'colorscheme rose-pine'
    end,
  },
}
