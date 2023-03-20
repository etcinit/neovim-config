vim.api.nvim_create_autocmd(
  { 'BufNewFile', 'BufRead' },
  {
    pattern = '*.tsx',
    callback = function()
      vim.bo.filetype = 'typescript.tsx'
    end,
  }
)
