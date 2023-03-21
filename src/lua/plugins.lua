-- If a lazy-lock.json file does not exist, but we have a
-- lazy-lock.initial.json file available, create a writeable copy.
--
-- This allow us to ship a lockfile with this repo, managed by home-manager,
-- ensuring the environment is reproducible while also giving the end-user the
-- option to update plugins manually.
--
-- If something breaks during na update, the user can always rever tback to
-- the state in this repo by copying the initial lockfile again.
local lockpath = vim.fn.stdpath("config") .. "/lazy-lock.json"
local initial_lockpath = vim.fn.stdpath("config") .. "/lazy-lock.initial.json"
if (not vim.loop.fs_stat(lockpath)) and vim.loop.fs_stat(initial_lockpath) then
  vim.loop.fs_copyfile(initial_lockpath, lockpath)
  vim.loop.fs_chmod(lockpath, tonumber("664", 8))
end

-- Install Lazy.nvim if it's not already available.
--
-- This should allow for this config to be usable even outside of a
-- home-manager/Nix environment.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  -- Prevent lazy.nvim from updating itself. The plugin will be managed
  -- externally to lock down the version used.
  { "folke/lazy.nvim", enabled = false },
  {
    'folke/tokyonight.nvim',
    config = require('config.tokyonight'),
  },
  {
    'nvim-treesitter/nvim-treesitter',
    config = require('config.treesitter'),
    build = function()
      local ts_update = require('nvim-treesitter.install')
        .update({ with_sync = true })

      ts_update()
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons', 'nvim-tree/nvim-tree.lua' },
    config = require('config.lualine'),
  },
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = require('config.tree')
  },
  {
    'lewis6991/gitsigns.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim'
    },
    config = require('config.gitsigns')
  },
  {
    'romgrk/barbar.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = require('config.barbar')
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    config = require('config.indent-blankline')
  },
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'saadparwaiz1/cmp_luasnip',
      'L3MON4D3/LuaSnip',
    },
    config = require('config.cmp'),
  },
  {
    'nvim-lua/lsp-status.nvim',
    config = require('config.lspstatus')
  },
  {
    'neovim/nvim-lspconfig',
    config = require('config.lspconfig'),
    after = 'lsp-status.nvim'
  },
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
    dependencies = { { 'nvim-lua/plenary.nvim' } },
    config = require('config.telescope'),
  },
  {
    'mfussenegger/nvim-dap',
    config = require('config.dap')
  },
  {
    'rcarriga/nvim-dap-ui',
    dependencies = {'nvim-dap'},
    config = require('config.dapui'),
  },
  'jbyuki/one-small-step-for-vimkind',
  {
    'petertriho/nvim-scrollbar',
    config = require('config.scrollbar'),
  },
  {
    'akinsho/toggleterm.nvim',
    config = require('config.toggleterm'),
  },
  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = require('config.trouble'),
  },
  {
    'jose-elias-alvarez/null-ls.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    after = 'nvim-lspconfig',
    config = require('config.null-ls'),
  },
  {
    'MunifTanjim/prettier.nvim',
    dependencies = {
      'neovim/nvim-lspconfig',
      'jose-elias-alvarez/null-ls.nvim',
    },
    config = require('config.prettier'),
  },
})
