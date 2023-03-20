local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end

  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function()
  use 'wbthomason/packer.nvim'
  use {
    'folke/tokyonight.nvim',
    config = require('config.tokyonight'),
  }
  use {
    'nvim-treesitter/nvim-treesitter',
    config = require('config.treesitter'),
    run = function()
      local ts_update = require('nvim-treesitter.install')
        .update({ with_sync = true })

      ts_update()
    end,
  }
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons' },
    config = require('config.lualine'),
  }
  use {
    'nvim-tree/nvim-tree.lua',
    requires = { 'nvim-tree/nvim-web-devicons' },
    config = require('config.tree')
  }
  use {
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    },
    config = require('config.gitsigns')
  }
  use {
    'romgrk/barbar.nvim',
    requires = { 'nvim-tree/nvim-web-devicons' },
    config = require('config.barbar')
  }
  use {
    "lukas-reineke/indent-blankline.nvim",
    config = require('config.indent-blankline')
  }
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'saadparwaiz1/cmp_luasnip',
      'L3MON4D3/LuaSnip',
    },
    config = require('config.cmp'),
  }
  use {
    'nvim-lua/lsp-status.nvim',
    config = require('config.lspstatus')
  }
  use {
    'neovim/nvim-lspconfig',
    config = require('config.lspconfig'),
    after = 'lsp-status.nvim'
  }
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
    requires = { { 'nvim-lua/plenary.nvim' } },
    config = require('config.telescope'),
  }
  use {
    'mfussenegger/nvim-dap',
    config = require('config.dap')
  }
  use {
    'rcarriga/nvim-dap-ui',
    config = require('config.dapui'),
    after = 'nvim-dap'
  }
  use 'jbyuki/one-small-step-for-vimkind'
  use {
    'petertriho/nvim-scrollbar',
    config = require('config.scrollbar'),
  }
  use {
    'akinsho/toggleterm.nvim',
    config = require('config.toggleterm'),
  }
  use {
    'folke/trouble.nvim',
    requires = { 'nvim-tree/nvim-web-devicons' },
    config = require('config.trouble'),
  }
  use {
    'jose-elias-alvarez/null-ls.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    after = 'nvim-lspconfig',
    config = require('config.null-ls'),
  }
  use {
    'MunifTanjim/prettier.nvim',
    requires = {
      'neovim/nvim-lspconfig',
      'jose-elias-alvarez/null-ls.nvim',
    },
    after = 'null-ls.nvim',
    config = require('config.prettier'),
  }

  if packer_bootstrap then
    require('packer').sync()
  end
end)
