local setup_telescope = function()
  local telescope = require('telescope')
  local builtin = require('telescope.builtin')
  local map = require('lib.utils').map

  -- Files / buffers
  map('n', '<leader>ff', builtin.find_files, {}, "Find: Files")
  map('n', '<leader>fb', builtin.buffers, {}, "Find: Buffers")
  map('n', '<leader>fg', builtin.live_grep, {}, "Find: Grep")

  -- General search
  map('n', '<leader>sa', builtin.builtin, {}, "Search: Telescope Finders")
  map('n', '<leader>sh', builtin.help_tags, {}, "Search: Help Tags")
  map('n', '<leader>sc', builtin.commands, {}, "Search: Commands")
  map('n', '<leader>sk', builtin.keymaps, {}, "Search: Keymaps")

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
