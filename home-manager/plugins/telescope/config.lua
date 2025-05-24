local setup_telescope = function()
  local telescope = require('telescope')
  local builtin = require('telescope.builtin')
  local map = require('lib.utils').map

  map('n', '<leader>fa', builtin.builtin, {}, "Telescope: Find Finders")
  map('n', '<leader>ff', builtin.find_files, {}, "Telescope: Find Files")
  map('n', '<leader>fg', builtin.live_grep, {}, "Telescope: Live Grep")
  map('n', '<leader>fb', builtin.buffers, {}, "Telescope: Find Buffers")
  map('n', '<leader>fh', builtin.help_tags, {}, "Telescope: Find Help Tags")
  map('n', '<leader>fc', builtin.commands, {}, "Telescope: Find Commands")
  map('n', '<leader>fk', builtin.keymaps, {}, "Telescope: Find Keymaps")

  telescope.setup {
    defaults = vim.tbl_extend(
      "force",
      require('telescope.themes').get_dropdown(), -- or get_cursor, get_ivy
      {
        preview = {
          filesize_limit = 0.5, -- MB
        },
      }
    )
  }

  telescope.load_extension("ui-select")
end

setup_telescope()
