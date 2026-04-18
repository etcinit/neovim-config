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
    ./plugins/conform
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

        require('options')
        require('mappings')
      '';
    };

    home.file.".config/nvim/after" = {
      source = ../src/after;
      target = ".config/nvim/after";
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
