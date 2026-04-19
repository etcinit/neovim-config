local opts = vim.o

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- I/O
opts.encoding = 'utf-8'

-- Input
opts.mouse = 'a'

-- Indentation
opts.smartindent = true
opts.tabstop = 2
opts.shiftwidth = 2
opts.expandtab = true
opts.softtabstop = 2
opts.list = true
vim.opt.listchars = {
  eol = '↴',
  space = '⋅',
  trail = '⋅',
  tab = '→ '
}

-- Line Numbers
opts.number = true

-- Theme
opts.termguicolors = true
opts.background = 'dark'

-- Ruler
opts.colorcolumn = '80'

-- Status Line
opts.showmode = false
opts.laststatus = 2

-- Highlight
opts.cursorline = true
