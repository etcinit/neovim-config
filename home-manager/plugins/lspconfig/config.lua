local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Shared config for all LSP servers.
vim.lsp.config('*', {
  capabilities = vim.tbl_deep_extend(
    "force",
    cmp_capabilities,
    {
      textDocument = {
        completion = {
          completionItem = {
            insertReplaceSupport = true,
            preselectSupport = true,
            snippetSupport = true,
          },
        },
      },
    }
  ),
})

-- Server-specific configs (servers with custom settings).
vim.lsp.config('nil_ls', {
  settings = {
    ['nil'] = {
      formatting = {
        command = { "nixfmt" },
      },
    },
  },
})

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      },
      telemetry = {
        enable = false,
      },
    },
  },
})

-- Enable all LSP servers.
vim.lsp.enable({
  'rust_analyzer',
  'hls',
  'nil_ls',
  'ts_ls',
  'eslint',
  'basedpyright',
  'ruff',
  'lua_ls',
  'nixd',
})

-- LSP keybindings via LspAttach autocmd.
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufnr = args.buf
    local opts = { noremap = true, silent = true, buffer = bufnr }

    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, vim.tbl_extend('force', opts, { desc = "LSP: Go to declaration" }))
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, vim.tbl_extend('force', opts, { desc = "LSP: Go to definition" }))
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, vim.tbl_extend('force', opts, { desc = "LSP: Hover" }))
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation,
      vim.tbl_extend('force', opts, { desc = "LSP: Go to implementation" }))
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help,
      vim.tbl_extend('force', opts, { desc = "LSP: Signature help" }))
    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder,
      vim.tbl_extend('force', opts, { desc = "LSP: Add workspace folder" }))
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder,
      vim.tbl_extend('force', opts, { desc = "LSP: Remove workspace folder" }))
    vim.keymap.set('n', '<leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, vim.tbl_extend('force', opts, { desc = "LSP: List workspace folders" }))
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition,
      vim.tbl_extend('force', opts, { desc = "LSP: Type definition" }))
    vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, vim.tbl_extend('force', opts, { desc = "LSP: Rename symbol" }))
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, vim.tbl_extend('force', opts, { desc = "LSP: Find references" }))
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action,
      vim.tbl_extend('force', opts, { desc = "LSP: Code action" }))

    vim.keymap.set('n', '<leader>cd', vim.diagnostic.open_float,
      vim.tbl_extend('force', opts, { desc = "Diagnostics: Open float" }))
    vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1 }) end, vim.tbl_extend('force', opts, { desc = "Diagnostics: Previous" }))
    vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1 }) end, vim.tbl_extend('force', opts, { desc = "Diagnostics: Next" }))
    vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist,
      vim.tbl_extend('force', opts, { desc = "Diagnostics: Set loclist" }))
    vim.keymap.set('n', '<leader>ss', function()
      require('telescope.builtin').lsp_document_symbols()
    end, vim.tbl_extend('force', opts, { desc = "LSP: Document symbols" }))
    vim.keymap.set('n', '<leader>cf', function()
      vim.lsp.buf.format({ async = true })
    end, vim.tbl_extend('force', opts, { desc = "LSP: Format" }))
  end,
})
