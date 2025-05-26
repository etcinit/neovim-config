local setup_trouble = function()
  local map = require('lib.utils').map
  local trouble = require('trouble')

  trouble.setup {
    warn_no_results = false,
    preview = {
      type = "split",
      relative = "win",
      position = "right",
      size = 0.3,
    },
    modes = {
      buffer_diagnostics = {
        mode = 'diagnostics',
        filter = { buf = 0 }
      }
    }
  }

  local map_opts = {
    silent = true,
    noremap = true,
  }

  map('n', '<leader>xx', function() trouble.toggle('diagnostics') end, map_opts, "Trouble: Diagnostics (Workspace)")
  map(
    'n',
    '<leader>xb',
    function() trouble.toggle('buffer_diagnostics') end,
    map_opts,
    "Trouble: Diagnostics (Current Buffer)"
  )
  map('n', '<leader>xl', function() trouble.toggle('loclist') end, map_opts, "Trouble: Location List")
  map('n', '<leader>xq', function() trouble.toggle('quickfix') end, map_opts, "Trouble: Quickfix")
  map(
    'n',
    '<leader>xr',
    function() trouble.toggle('lsp_references') end,
    map_opts,
    "Trouble: LSP References"
  )
  map(
    'n',
    '<leader>xd',
    function() trouble.toggle('lsp_definitions') end,
    map_opts,
    "Trouble: LSP Definitions"
  )
  map(
    'n',
    '<leader>xD',
    function() trouble.toggle('lsp_declarations') end,
    map_opts,
    "Trouble: LSP Declarations"
  )
  map(
    'n',
    '<leader>xt',
    function() trouble.toggle('lsp_type_definitions') end,
    map_opts,
    "Trouble: LSP Type Definitions"
  )
end

setup_trouble();
