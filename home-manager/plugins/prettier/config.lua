local prettier_filetypes = {
  "css",
  "graphql",
  "html",
  "javascript",
  "javascriptreact",
  "json",
  "less",
  "markdown",
  "scss",
  "typescript",
  "typescriptreact",
  "yaml",
};

local function setup_prettier()
  local prettier = require("prettier")

  prettier.setup({
    bin = 'prettierd',
    filetypes = prettier_filetypes,
  })
end

lazyhooks.load_on_filetypes(
  'prettier',
  prettier_filetypes,
  setup_prettier
)
