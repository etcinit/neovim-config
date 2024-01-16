{pkgs, ...}: {
  config = {
    programs.neovim.plugins = [
      {
        type = "lua";
        config = builtins.readFile ./config.lua;
        plugin = pkgs.vimPlugins.null-ls-nvim;
      }
      pkgs.vimPlugins.plenary-nvim
    ];
  };
}
