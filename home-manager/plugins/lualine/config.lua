require('lualine').setup {
  extensions = {'nvim-tree'},
  options = {
    globalstatus = false,
    theme = 'tokyonight',
  },
  sections = {
    lualine_c = {
      'filename',
      function() return vim.lsp.status() end,
    }
  }
}
