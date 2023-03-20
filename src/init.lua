vim.g.mapleader = ","

-- Plugins
require('plugins')

-- Options
require('options')

-- Mappings
require('mappings')

-- Color theme
--vim.api.nvim_command("colorscheme tokyonight")

-- Misc
vim.api.nvim_command("syntax on")
vim.api.nvim_command("filetype plugin indent on")


