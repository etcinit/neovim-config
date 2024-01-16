require('lualine').setup {
  extensions = {'nvim-tree'},
  options = {
    globalstatus = false,
    theme = 'tokyonight',
  },
  sections = {
    lualine_c = {
      'file',
      "require'lsp-status'.status()",
    }
  }
}
