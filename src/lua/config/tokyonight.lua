return function()
  local tokyonight = require('tokyonight')

  tokyonight.setup({
    style = "storm",
    --transparent = true,
    styles = {
      sidebars = "dark",
      floats = "dark",
    },
    --dim_inactive = true,
    lualine_bold = true,
    use_background = false,
  })

  vim.api.nvim_command("colorscheme tokyonight-moon")
end
