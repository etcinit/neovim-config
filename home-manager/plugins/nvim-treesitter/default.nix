{pkgs, ...}: let
  parsers = with pkgs.vimPlugins.nvim-treesitter-parsers; [
    python
    cpp
    nix
    haskell
    rust
    typescript
    markdown
  ];
in {
  config = {
    programs.neovim = {
      plugins =
        [
          {
            type = "lua";
            config = builtins.readFile ./config.lua;
            plugin = pkgs.vimPlugins.nvim-treesitter;
          }
        ]
        ++ parsers;
    };
  };
}
