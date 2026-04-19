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
      preserve_window_proportions = true,
    },
    actions = {
      open_file = {
        resize_window = true,
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

  -- Close Neovim when nvim-tree is the last window remaining.
  -- Without this, :q on the last buffer leaves nvim-tree expanded full-screen.
  vim.api.nvim_create_autocmd('QuitPre', {
    callback = function()
      local tree_wins = {}
      local floating_wins = {}
      local wins = vim.api.nvim_list_wins()

      for _, w in ipairs(wins) do
        local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
        if bufname:match('NvimTree_') ~= nil then
          table.insert(tree_wins, w)
        end
        if vim.api.nvim_win_get_config(w).relative ~= '' then
          table.insert(floating_wins, w)
        end
      end

      if #wins - #floating_wins - #tree_wins == 1 then
        for _, w in ipairs(tree_wins) do
          vim.api.nvim_win_close(w, true)
        end
      end
    end,
  })

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
