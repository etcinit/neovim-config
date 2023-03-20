return function()
  local ts = require 'nvim-treesitter.configs'

  ts.setup {
    ensure_installed = {
      'python',
      'cpp',
      'nix',
      'haskell',
      'rust',
      'typescript',
      'markdown'
    },
    highlight = {
      enable = true
    }
  }
end
