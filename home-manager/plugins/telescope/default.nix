{pkgs, ...}: {
  config = {
    programs.neovim.plugins = [
      {
        type = "lua";
        config = builtins.readFile ./config.lua;
        plugin = pkgs.vimPlugins.telescope-nvim;
      }
      pkgs.vimPlugins.plenary-nvim
      pkgs.vimPlugins.telescope-ui-select-nvim
    ];
  };
}
