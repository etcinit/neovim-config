local setup_telescope = function()
  local builtin = require('telescope.builtin')
  local map = require('lib.utils').map

  map('n', '<leader>fa', builtin.builtin, {})
  map('n', '<leader>ff', builtin.find_files, {})
  map('n', '<leader>fg', builtin.live_grep, {})
  map('n', '<leader>fb', builtin.buffers, {})
  map('n', '<leader>fh', builtin.help_tags, {})
  map('n', '<leader>fc', builtin.commands, {})
end

setup_telescope()
