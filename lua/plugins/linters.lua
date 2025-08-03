-- Example assuming you configure nvim-lint in lua/plugins/lint.lua or similar

return {
  'mfussenegger/nvim-lint',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local lint = require 'lint'

    lint.linters_by_ft = {
      elixir = { 'credo' },
      typescript = { 'biomejs' },
      javascript = { 'biomejs' },
      python = { 'ruff' },
    }

    -- Autocommand to run linting on specific events
    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
      group = vim.api.nvim_create_augroup('nvim-lint', { clear = true }),
      callback = function()
        vim.defer_fn(function()
          lint.try_lint()
        end, 50)
      end,
    })
  end,
}
