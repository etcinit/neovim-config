return function()
  require("toggleterm").setup({
    open_mapping = [[<c-\>]],
    winbar = {
      enable = true,
    }
  })
end
