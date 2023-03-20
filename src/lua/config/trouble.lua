return function()
  local map = require('lib.utils').map
  local trouble = require('trouble')

  trouble.setup()

  local map_opts = {
    silent = true,
    noremap = true,
  }

  map('n', '<leader>xx', trouble.toggle, map_opts)
  map(
    'n',
    '<leader>xw',
    function() trouble.toggle('workspace_diagnostics') end,
    map_opts
  )
  map(
    'n',
    '<leader>xd',
    function() trouble.toggle('document_diagnostics') end,
    map_opts
  )
  map('n', '<leader>xl', function() trouble.toggle('loclist') end, map_opts)
  map('n', '<leader>xq', function() trouble.toggle('quickfix') end, map_opts)
  map(
    'n',
    '<leader>xr',
    function() trouble.toggle('lsp_references') end,
    map_opts
  )
end
