return function()
  require("ibl").setup {
    exclude = {
      buftypes = { "terminal" },
    },
    indent = {
      char = '|',
    },
  }
end
