{pkgs, ...}: {
  config = {
    programs.neovim.plugins = [
      {
        type = "lua";
        config = builtins.readFile ./config.lua;
        plugin = pkgs.vimPlugins.nvim-tree-lua;
      }
      pkgs.vimPlugins.nvim-web-devicons
    ];
  };
}
