return {
  'monaqa/dial.nvim',
  config = function()
    local augend = require 'dial.augend'
    require('dial.config').augends:register_group {
      default = {
        augend.integer.alias.decimal,
        augend.integer.alias.hex,
        augend.date.alias['%Y/%m/%d'],
        augend.date.alias['%Y-%m-%d'],
        augend.date.alias['%m/%d'],
        augend.date.alias['%H:%M'],
        augend.constant.alias.ja_weekday_full,
        augend.constant.alias.bool,
        augend.constant.new {
          elements = { '[ ]', '[x]' },
          word = false,
          cyclic = true,
        },
      },

      visual = {
        augend.integer.alias.decimal,
        augend.integer.alias.hex,
        augend.date.alias['%Y/%m/%d'],
        augend.constant.alias.bool,
        augend.constant.alias.alpha,
        augend.constant.alias.Alpha,
        augend.constant.new {
          elements = { '[ ]', '[x]' },
          word = false,
          cyclic = true,
        },
      },
    }
  end,
}
