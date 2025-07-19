return {
  {
    'stevearc/conform.nvim',
    opts = {
      formatters = {
        ['markdown-toc'] = {
          condition = function(_, ctx)
            for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
              if line:find '<!%-%- toc %-%->' then
                return true
              end
            end
          end,
        },
        ['markdownlint-cli2'] = {
          condition = function(_, ctx)
            local diag = vim.tbl_filter(function(d)
              return d.source == 'markdownlint'
            end, vim.diagnostic.get(ctx.buf))
            return #diag > 0
          end,
        },
        ['biome'] = {
          command = 'biome',
          args = {
            'check',
            '--formatter-enabled=true',
            '--linter-enabled=false',
            '--organize-imports-enabled=true',
            '--write',
            '--stdin-file-path',
            '$FILENAME',
          },
        },
      },
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'isort', 'black' },
        rust = { 'rustfmt' },
        ['javascript'] = { 'biome' },
        ['javascriptreact'] = { 'biome' },
        ['typescript'] = { 'biome' },
        ['typescriptreact'] = { 'biome' },
        ['json'] = { 'biome-check' },
        ['css'] = { 'biome-check' },
        markdown = { 'prettier', 'markdownlint-cli2', 'markdown-toc' },
        yaml = { 'prettier' },
        sh = { 'shfmt' },
        bash = { 'shfmt' },
        zig = { 'zig fmt' },
        ['markdown.mdx'] = { 'prettier', 'markdownlint-cli2', 'markdown-toc' },
      },

      format_on_save = {
        timeout_ms = 500,
        lsp_format = 'fallback',
      },
    },
  },
}
