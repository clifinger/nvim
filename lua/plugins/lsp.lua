return {
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'williamboman/mason.nvim', opts = {} },
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    { 'j-hui/fidget.nvim', opts = {} },
  },
  config = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        local buffer = event.buf

        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          if buffer and vim.api.nvim_buf_is_valid(buffer) then
            vim.keymap.set(mode, keys, func, { buffer = buffer, desc = 'LSP: ' .. desc })
          end
        end

        map('gd', vim.lsp.buf.definition, 'Goto Definition')
        map('gr', vim.lsp.buf.references, 'Goto References')
        map('gI', vim.lsp.buf.implementation, 'Goto Implementation')
        map('<leader>D', vim.lsp.buf.type_definition, 'Type Definition')
        map('<leader>cr', vim.lsp.buf.rename, 'Rename')
        map('<leader>ca', vim.lsp.buf.code_action, 'Code Action', { 'n', 'x' })
        map('gD', vim.lsp.buf.declaration, 'Goto Declaration')
        map('K', vim.lsp.buf.hover, 'Hover Documentation')
        map('<C-k>', vim.lsp.buf.signature_help, 'Signature Help')
        map('<leader>wa', vim.lsp.buf.add_workspace_folder, 'Workspace Add Folder')
        map('<leader>wr', vim.lsp.buf.remove_workspace_folder, 'Workspace Remove Folder')
        map('<leader>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, 'Workspace List Folders')

        if client and client.supports_method 'textDocument/documentHighlight' then
          local highlight_group = vim.api.nvim_create_augroup('lsp-highlight-symbols', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = buffer,
            group = highlight_group,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = buffer,
            group = highlight_group,
            callback = vim.lsp.buf.clear_references,
          })
        end
      end,
    })

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local cmp_ok, cmp_blink = pcall(require, 'blink.cmp')
    if cmp_ok then
      capabilities = cmp_blink.get_lsp_capabilities(capabilities)
    end

    local servers = {
      bashls = {},
      marksman = {},
      elixirls = {},
      lua_ls = {
        settings = {
          Lua = {
            runtime = { version = 'LuaJIT' },
            workspace = {
              checkThirdParty = false,
              library = {
                '${3rd}/luv/library',
                vim.api.nvim_get_runtime_file('', true),
              },
            },
            diagnostics = { disable = { 'missing-fields' }, globals = { 'vim', 'use', 'Snacks' } },
            format = {
              enable = false,
            },
          },
        },
      },
      tsserver = {},
      biome = {},
      tailwindcss = {},
    }

    local ensure_installed_tools = {
      'stylua',
      'prettierd',
      'biome',
      'bash-language-server',
      'marksman',
      'elixir-ls',
      'lua-language-server',
      'typescript-language-server',
      'tailwindcss-language-server',
      'markdownlint-cli2',
      'markdown-toc',
    }
    local unique_tools = {}
    for _, tool in ipairs(ensure_installed_tools) do
      unique_tools[tool] = true
    end
    require('mason-tool-installer').setup {
      ensure_installed = vim.tbl_keys(unique_tools),
    }

    require('mason-lspconfig').setup {
      ensure_installed = {},
      automatic_installation = false,
      handlers = {
        function(server_name)
          if server_name == 'lua_ls' then
            return
          end

          local server_config = servers[server_name] or {}
          server_config.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server_config.capabilities or {})
          require('lspconfig')[server_name].setup(server_config)
        end,
      },
    }

    local lua_ls_config = servers.lua_ls or {}
    lua_ls_config.capabilities = vim.tbl_deep_extend('force', {}, capabilities, lua_ls_config.capabilities or {})
    require('lspconfig').lua_ls.setup(lua_ls_config)
  end,
}
