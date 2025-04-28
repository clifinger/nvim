-- lua/plugins/rose-pine.lua
return {
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    config = function()
      require('rose-pine').setup {
        dark_variant = 'moon',
        disable_italics = true,
        styles = {
          bold = true,
          italic = true,
          transparency = false,
        },
      }
      -- function to toggle dark and light mode by setting vim.o.background
      local function toggle_dark_light()
        if vim.o.background == 'dark' then
          vim.o.background = 'light'
        else
          vim.o.background = 'dark'
        end
      end
      vim.keymap.set('n', '<leader>tl', toggle_dark_light, { desc = 'Toggle dark/light mode' })
      vim.cmd 'colorscheme rose-pine'
    end,
  },
}
