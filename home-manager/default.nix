{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./lazy-nvim.nix
  ];

  config = {
    programs.neovim = {
      enable = true;

      defaultEditor = true;
    };

    home.file.".config/nvim/init.lua" = {
      source = ../src/init.lua;
      target = ".config/nvim/init.lua";
    };
    home.file.".config/nvim/lazy-lock.initial.json" = {
      source = ../src/lazy-lock.initial.json;
      target = ".config/nvim/lazy-lock.initial.json";
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
