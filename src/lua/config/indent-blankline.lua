return function()
  require("indent_blankline").setup {
    exclude = {
      buftypes = { "terminal" },
    },
    indent = {
      char = '|',
    },
  }
end
