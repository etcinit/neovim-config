{pkgs, ...}: {
  config = {
    programs.neovim.plugins = [
      {
        type = "lua";
        config = builtins.readFile ./config.lua;
        optional = true;
        plugin = pkgs.vimUtils.buildVimPlugin {
          pname = "prettier.nvim";
          version = "16-06-2023";
          src = pkgs.fetchFromGitHub {
            owner = "MunifTanjim";
            repo = "prettier.nvim";
            rev = "d98e732cb73690b07c00c839c924be1d1d9ac5c2";
            sha256 = "sha256-4xq+caprcQQotvBXnWWSsMwVB2hc5uyjrhT1dPBffXI=";
          };
          dependencies = [ pkgs.vimPlugins.nvim-lspconfig ];
        };
      }
    ];
  };
}
