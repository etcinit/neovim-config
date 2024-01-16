{pkgs, ...}: {
  config = {
    programs.neovim.plugins = [
      {
        type = "lua";
        config = ''
          local tokyonight = require('tokyonight')

          vim.api.nvim_command("colorscheme tokyonight-moon")

          tokyonight.setup({
            style = "moon",
            --transparent = true,
            styles = {
              sidebars = "dark",
              floats = "dark",
            },
            --dim_inactive = true,
            lualine_bold = true,
            use_background = false,
          })
        '';
        plugin = pkgs.vimPlugins.tokyonight-nvim;
      }
    ];
  };
}
