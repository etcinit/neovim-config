local function load_on_filetypes(module, filetypes, setup)
  vim.api.nvim_create_autocmd("FileType", {
      pattern = table.concat(filetypes, ","),
      callback = function()
          vim.cmd("packadd " .. module)
      end
  })
end

return {
  load_on_filetypes = load_on_filetypes
}
