{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./plugins/barbar
    ./plugins/cmp
    ./plugins/dap
    ./plugins/dap-ui
    ./plugins/gitsigns
    ./plugins/indent-blankline
    ./plugins/lspconfig
    ./plugins/lualine
    ./plugins/nvim-tree
    ./plugins/nvim-treesitter
    ./plugins/one-small-step-for-vimkind
    ./plugins/prettier
    ./plugins/scrollbar
    ./plugins/telescope
    ./plugins/toggleterm
    ./plugins/tokyonight
    ./plugins/trouble
  ];

  config = {
    programs.neovim = {
      enable = true;

      defaultEditor = true;

      extraLuaConfig = ''
        vim.g.mapleader = ","

        -- Options
        require('options')

        -- Mappings
        require('mappings')

        -- Misc
        vim.api.nvim_command("syntax on")
        vim.api.nvim_command("filetype plugin indent on")

        -- Hooks
        local lazyhooks = require('lib.lazyhooks');
      '';
    };

    home.file.".config/nvim/after" = {
      source = ../src/after;
      target = ".config/nvim/after";
    };
    home.file.".config/nvim/ftdetect" = {
      source = ../src/ftdetect;
      target = ".config/nvim/ftdetect";
    };
    home.file.".config/nvim/lua" = {
      source = ../src/lua;
      target = ".config/nvim/lua";
    };

    home.packages = with pkgs;
      [
        neovim-remote
        # GCC is needed by some plugins.
        gcc
      ]
      ++ lib.optional pkgs.stdenv.isLinux pkgs.wl-clipboard;
  };
}
