-- lua/plugins/rose-pine.lua
return {
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    config = function()
      local rp = require 'rose-pine'

      local rose_pine_base_config = {
        dark_variant = 'moon',
        disable_italics = false,
        styles = {
          bold = true,
          italic = true,
        },
      }

      local function apply_theme_settings(is_target_dark)
        local set_transparent = is_target_dark

        rose_pine_base_config.transparent_background = set_transparent
        rose_pine_base_config.styles.transparency = set_transparent

        if is_target_dark then
          vim.o.background = 'dark'
        else
          vim.o.background = 'light'
        end

        rp.setup(rose_pine_base_config)
        vim.cmd 'colorscheme rose-pine'
      end

      apply_theme_settings(vim.o.background == 'dark')

      local function toggle_background_mode()
        if vim.o.background == 'dark' then
          apply_theme_settings(false)
        else
          apply_theme_settings(true)
        end
      end

      vim.keymap.set('n', '<leader>ut', toggle_background_mode, { desc = 'Toggle Rose-pine dark/light & transparency' })
    end,
  },
}
