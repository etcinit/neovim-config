-- nvim-treesitter's `main` branch (the rewrite shipped in nixpkgs 26.05) no
-- longer exposes the old `require('nvim-treesitter.configs').setup{}` API.
-- Parsers are provided by Nix (see default.nix), so all we need to do is turn
-- on highlighting (provided by Neovim core) and the experimental treesitter
-- indentation per buffer, for the filetypes we ship parsers for.
local filetypes = {
  'python',
  'cpp',
  'nix',
  'haskell',
  'rust',
  'typescript',
  'markdown',
}

vim.api.nvim_create_autocmd('FileType', {
  pattern = filetypes,
  callback = function(args)
    -- Highlighting is provided by Neovim core (:h treesitter-highlight).
    -- Guard against a missing parser so we don't set indentexpr without one.
    if pcall(vim.treesitter.start) then
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})
