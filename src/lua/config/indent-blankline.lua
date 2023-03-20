return function()
  require("indent_blankline").setup{
    buftype_exclude = {"terminal"},
    char = '|',
    show_current_context = true,
    space_char_blankline = " "
  }
end

