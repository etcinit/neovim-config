local setup_lspconfig = function()
  local lspconfig = require('lspconfig')
  local lsp_status = require('lsp-status')

  local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()

  local on_attach = function(client, bufnr)
    local opts = {
      noremap = true,
      silent = true,
      buffer = bufnr,
    }

    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    --vim.keymap.set('v', '<leader>ca', vim.lsp.buf.range_code_action, opts)

    vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)
    vim.keymap.set('n', '<leader>so', function()
      require('telescope.builtin').lsp_document_symbols()
    end, opts)
    vim.keymap.set('n', '<space>f', function ()
      vim.lsp.buf.format { async = true }
    end, opts)

    lsp_status.on_attach(client)
  end

  local servers = {
    rust_analyzer = {},
    hls = {},
    nixd = {},
    tsserver = {},
    eslint = {},
    lua_ls = {
      settings = {
        Lua = {
          runtime = {
            -- Neovim uses LuaJIT.
            version = 'LuaJIT',
          },
          diagnostics = {
            -- Get the language server to recognize the `vim` global.
            globals = {'vim'},
          },
          workspace = {
            -- Make the server aware of the Neovim runtime.
            library = vim.api.nvim_get_runtime_file("", true),
          },
          -- Do not send telemetry data containing a randomized but unique
          -- identifier.
          telemetry = {
            enable = false,
          },
        }
      }
    },
  }

  for ls, config in pairs(servers) do
    local capabilities = vim.tbl_extend(
      "keep",
      config.capabilities or {},
      lspconfig[ls].capabilities or {},
      lsp_status.capabilities,
      cmp_capabilities,
      {
        textDocument = {
          completion = {
            completionItem = {
              insertReplaceSupport = true,
              preselectSupport = true,
              snippetSupport = true
            }
          }
        }
      }
    )

    lspconfig[ls].setup {
      on_attach = on_attach,
      capabilities = capabilities,
      settings = config.settings or {},
    }
  end
end

setup_lspconfig()
