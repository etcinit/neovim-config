{ pkgs, ... }: {
  config = {
    programs.neovim.plugins = [
      {
        type = "lua";
        config = "";
        plugin = pkgs.vimPlugins.one-small-step-for-vimkind;
      }
    ];
  };
}
