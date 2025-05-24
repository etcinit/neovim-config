local setup_tree = function()
  require('nvim-tree').setup {
    update_focused_file = {
      enable = true,
      ignore_list = {},
    },
    sync_root_with_cwd = true,
    view = {
      width = 30,
      side = 'left',
    },
    actions = {
      open_file = {
        resize_window = false,
      },
    },
    renderer = {
      highlight_opened_files = 'name',
      indent_markers = {
        enable = false,
      },
      icons = {
        show = {
          file = true,
          folder = true,
          folder_arrow = true,
          git = true,
        },
      },
    },
    diagnostics = {
      enable = true,
    },
  }

  -- Bindings
  vim.keymap.set('n', '<leader>e', function()
    local nt_api = require("nvim-tree.api")

    nt_api.tree.toggle()
  end, { desc = "Neovim Tree: Toggle" })

  vim.keymap.set('n', '<leader>o', function()
    local nt_api = require("nvim-tree.api")

    nt_api.tree.focus()
  end, { desc = "Neovim Tree: Focus" })

  -- Barbar Integration
  local nvim_tree_events = require('nvim-tree.events')
  local bufferline_api = require('barbar.api')

  local function get_tree_size()
    return require 'nvim-tree.view'.View.width
  end

  nvim_tree_events.subscribe('TreeOpen', function()
    bufferline_api.set_offset(get_tree_size())
  end)

  nvim_tree_events.subscribe('Resize', function()
    bufferline_api.set_offset(get_tree_size())
  end)

  nvim_tree_events.subscribe('TreeClose', function()
    bufferline_api.set_offset(0)
  end)

  -- Opening on startup
  vim.api.nvim_create_autocmd({ 'VimEnter' }, {
    callback = function(data)
      -- buffer is a real file on the disk
      local real_file = vim.fn.filereadable(data.file) == 1

      -- buffer is a [No Name]
      local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

      -- only files please
      if not real_file and not no_name then
        return
      end

      -- open the tree but don't focus it
      require("nvim-tree.api").tree.toggle({ focus = false });
    end
  })
end

setup_tree()
