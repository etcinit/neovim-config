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
}

local formatters_by_ft = {}
for _, ft in ipairs(prettier_filetypes) do
  formatters_by_ft[ft] = { "prettierd" }
end

require("conform").setup({
  formatters_by_ft = formatters_by_ft,
  format_on_save = {
    timeout_ms = 2000,
    lsp_format = "fallback",
  },
})
