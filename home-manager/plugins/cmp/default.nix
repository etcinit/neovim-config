{pkgs, ...}: let
  subplugins = with pkgs.vimPlugins; [
    cmp-nvim-lsp
    cmp-buffer
    cmp-path
    cmp-cmdline
    cmp_luasnip
    luasnip
  ];
in {
  config = {
    programs.neovim.plugins =
      [
        {
          type = "lua";
          config = builtins.readFile ./config.lua;
          plugin = pkgs.vimPlugins.nvim-cmp;
        }
      ]
      ++ subplugins;
  };
}
