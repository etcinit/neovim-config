return function()
  local lualine = require('lualine');

  lualine.setup {
    options = {
      globalstatus = true,
      theme = 'tokyonight',
    },
    sections = {
      lualine_c = {
        'file',
        "require'lsp-status'.status()",
      }
    }
  }
end
