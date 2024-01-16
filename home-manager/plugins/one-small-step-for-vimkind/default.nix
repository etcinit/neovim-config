{pkgs, ...}: {
  config = {
    programs.neovim.plugins = [
      {
        type = "lua";
        config = ''
        '';
        plugin = pkgs.vimUtils.buildVimPlugin {
          pname = "one-small-step-for-vimkind";
          version = "03-12-2023";
          src = pkgs.fetchFromGitHub {
            owner = "jbyuki";
            repo = "one-small-step-for-vimkind";
            rev = "aaee281bdaa3141d9d0cdb3dec468532da61124f";
            sha256 = "sha256-VACSEN50FSzQmAjpFW45yXvc68wnRhzfboYvps3sOBE=";
          };
        };
      }
    ];
  };
}
