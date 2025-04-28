return {
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'williamboman/mason.nvim', opts = {} },
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    { 'j-hui/fidget.nvim', opts = {} },
  },
  config = function()
    local lsp_augroups = {}
    local function setup_format_on_save(client, buffer)
      if client.supports_method 'textDocument/codeAction' then
        local format_group = lsp_augroups[buffer]
        if not format_group then
          format_group = vim.api.nvim_create_augroup('LspFormat_' .. buffer, { clear = false })
          lsp_augroups[buffer] = format_group
        end

        local ts_ft = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx', 'vue' }
        if vim.tbl_contains(ts_ft, vim.bo[buffer].filetype) then
          vim.api.nvim_create_autocmd('BufWritePre', {
            group = format_group,
            buffer = buffer,
            callback = function()
              vim.lsp.buf.code_action { context = { only = { 'source.addMissingImports.ts' } }, apply = true, bufnr = buffer }
            end,
          })
        end
      end
    end

    vim.api.nvim_create_autocmd('BufDelete', {
      callback = function(args)
        if lsp_augroups[args.buf] then
          vim.api.nvim_del_augroup_by_id(lsp_augroups[args.buf])
          lsp_augroups[args.buf] = nil
        end
      end,
    })

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

        if client and client.name == 'vtsls' then
          setup_format_on_save(client, buffer)

          map('gD', function()
            local params = vim.lsp.util.make_position_params()
            client.request('workspace/executeCommand', {
              command = 'typescript.goToSourceDefinition',
              arguments = { params.textDocument.uri, params.position },
              open = true,
            }, function(err, result)
              if err then
                print('Error executing goToSourceDefinition:', vim.inspect(err))
              end
            end)
          end, 'Goto Source Definition')

          map('gR', function()
            client.request('workspace/executeCommand', {
              command = 'typescript.findAllFileReferences',
              arguments = { vim.uri_from_bufnr(buffer) },
              open = true,
            }, function(err, result)
              if err then
                print('Error executing findAllFileReferences:', vim.inspect(err))
              end
            end)
          end, 'File References')

          map('<leader>co', function()
            require('conform').format { bufnr = buffer }
          end, 'Format (Conform)')
          map('<leader>cM', function()
            vim.lsp.buf.code_action { context = { only = { 'source.addMissingImports.ts' } }, apply = true }
          end, 'Add missing imports')
          map('<leader>cu', function()
            vim.lsp.buf.code_action { context = { only = { 'source.removeUnused.ts' } }, apply = true }
          end, 'Remove unused imports')
          map('<leader>cD', function()
            require('conform').format { bufnr = buffer }
          end, 'Format/Fix (Conform)')
          map('<leader>cV', function()
            client.request('workspace/executeCommand', { command = 'typescript.selectTypeScriptVersion' }, function(err, result)
              if err then
                print('Error executing selectTypeScriptVersion:', vim.inspect(err))
              end
            end)
          end, 'Select TS workspace version')
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
            format = { enable = false },
          },
        },
      },
      tsserver = {
        enabled = false,
      },
      ts_ls = {
        enabled = false,
      },
      biome = {},
      tailwindcss = {},
      vtsls = {
        filetypes = {
          'javascript',
          'javascriptreact',
          'javascript.jsx',
          'typescript',
          'typescriptreact',
          'typescript.tsx',
          'vue',
        },
        settings = {
          complete_function_calls = true,
          vtsls = {
            enableMoveToFileCodeAction = true,
            autoUseWorkspaceTsdk = true,
            experimental = {
              maxInlayHintLength = 30,
              completion = {
                enableServerSideFuzzyMatch = true,
                entriesLimit = 100,
              },
            },
          },
          typescript = {
            updateImportsOnFileMove = { enabled = 'always' },
            suggest = {
              completeFunctionCalls = true,
              includeCompletionsForModuleExports = true,
              includeCompletionsWithInsertText = true,
              autoImports = true,
            },
            preferences = {
              importModuleSpecifierPreference = 'relative',
              importModuleSpecifierEnding = 'js',
              allowTextChangesInNewFiles = true,
              providePrefixAndSuffixTextForRename = true,
              allowImportingTsExtensions = true,
              autoImportFileExcludePatterns = {},
            },
            inlayHints = {
              enumMemberValues = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              parameterNames = { enabled = 'literals' },
              parameterTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              variableTypes = { enabled = false },
            },
          },
          javascript = {
            updateImportsOnFileMove = { enabled = 'always' },
            suggest = {
              completeFunctionCalls = true,
              autoImports = true,
            },
            preferences = {
              importModuleSpecifierPreference = 'relative',
              importModuleSpecifierEnding = 'js',
              allowTextChangesInNewFiles = true,
              providePrefixAndSuffixTextForRename = true,
              autoImportFileExcludePatterns = {},
            },
            inlayHints = {
              enumMemberValues = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              parameterNames = { enabled = 'literals' },
              parameterTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              variableTypes = { enabled = false },
            },
          },
        },
      },
      emmet_language_server = {
        filetypes = {
          'astro',
          'css',
          'eruby',
          'html',
          'javascript',
          'javascriptreact',
          'less',
          'php',
          'pug',
          'sass',
          'scss',
          'typescriptreact',
          'vue',
          'heex',
        },
        init_options = {
          excludeLanguages = {},
          extensionsPath = {},
          preferences = {},
          showAbbreviationSuggestions = true,
          showExpandedAbbreviation = 'always',
          showSuggestionsAsSnippets = false,
          syntaxProfiles = {},
          variables = {},
        },
      },
    }

    local ensure_installed_tools = {
      'stylua',
      'prettierd',
      'biome',
      'bash-language-server',
      'marksman',
      'elixir-ls',
      'lua-language-server',
      'vtsls',
      'tailwindcss-language-server',
      'markdownlint-cli2',
      'markdown-toc',
      'js-debug-adapter',
      'emmet-language-server',
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
          if server_name == 'tsserver' or server_name == 'ts_ls' then
            return
          end

          local server_config = servers[server_name] or {}
          server_config.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server_config.capabilities or {})

          if server_name == 'vtsls' then
            local original_on_attach = server_config.on_attach
            server_config.on_attach = function(client, buffer)
              if original_on_attach then
                original_on_attach(client, buffer)
              end
              client.commands['_typescript.moveToFileRefactoring'] = function(command, ctx)
                local action, uri, range = unpack(command.arguments)
                local function move(newf)
                  client.request('workspace/executeCommand', {
                    command = command.command,
                    arguments = { action, uri, range, newf },
                  })
                end
                local fname = vim.uri_to_fname(uri)
                client.request('workspace/executeCommand', {
                  command = 'typescript.tsserverRequest',
                  arguments = {
                    'getMoveToRefactoringFileSuggestions',
                    {
                      file = fname,
                      startLine = range.start.line + 1,
                      startOffset = range.start.character + 1,
                      endLine = range['end'].line + 1,
                      endOffset = range['end'].character + 1,
                    },
                  },
                }, function(_, result)
                  if not result or not result.body or not result.body.files then
                    return
                  end
                  local files = result.body.files
                  table.insert(files, 1, 'Enter new path...')
                  vim.ui.select(files, {
                    prompt = 'Select move destination:',
                    format_item = function(f)
                      return vim.fn.fnamemodify(f, ':~:.')
                    end,
                  }, function(f)
                    if f and f:find '^Enter new path' then
                      vim.ui.input({
                        prompt = 'Enter move destination:',
                        default = vim.fn.fnamemodify(fname, ':h') .. '/',
                        completion = 'file',
                      }, function(newf)
                        return newf and move(newf)
                      end)
                    elseif f then
                      move(f)
                    end
                  end)
                end)
              end
            end
          end

          require('lspconfig')[server_name].setup(server_config)
        end,
      },
    }

    local lua_ls_config = servers.lua_ls or {}
    lua_ls_config.capabilities = vim.tbl_deep_extend('force', {}, capabilities, lua_ls_config.capabilities or {})
    require('lspconfig').lua_ls.setup(lua_ls_config)
  end,
}
