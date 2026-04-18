{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      flake-utils,
      nixpkgs,
      home-manager,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = (import nixpkgs) {
          inherit system;
        };

        # Bundle src/ (lua/, after/, ftdetect/) as a vim plugin so it lands
        # on neovim's runtimepath without home-manager activation.
        runtimePlugin = pkgs.vimUtils.buildVimPlugin {
          pname = "neovim-config-runtime";
          version = "dev";
          src = ./src;
        };

        # Evaluate the home-manager module to extract the final neovim package.
        hmConfig = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            self.nixosModules.home-manager.neovim-config
            {
              home.username = "neovim";
              home.homeDirectory = "/home/neovim";
              home.stateVersion = "23.11";

              # Inject the runtime plugin so lua/options.lua etc. are available.
              programs.neovim.plugins = [ runtimePlugin ];
            }
          ];
        };

        neovimPackage = hmConfig.config.programs.neovim.finalPackage;

        # Extract the init.lua that home-manager generates (it contains
        # extraLuaConfig + all plugin configs). Without this, neovim launches
        # with plugins on rtp but no configuration applied.
        initLua = pkgs.writeText "init.lua" hmConfig.config.xdg.configFile."nvim/init.lua".text;
      in
      {
        packages =
          {
            resize-tty = pkgs.writeShellScriptBin "resize-tty" ''
              echo -ne '\e[s\e[5000;5000H'
              IFS='[;' read -p $'\e[6n' -d R -a pos -rs
              echo -ne '\e[u'

              ${pkgs.coreutils-full}/bin/stty cols "''${pos[2]}" rows "''${pos[1]}"

              export TERM=xterm-256color
            '';

            neovim = pkgs.writeShellScriptBin "nvim" ''
              exec env NVIM_APPNAME=nvim-config-test ${neovimPackage}/bin/nvim -u ${initLua} "$@"
            '';

            default = self.packages.${system}.neovim;
          }
          // pkgs.lib.optionalAttrs pkgs.stdenv.isLinux {
            nixosConfigurations.vm = nixpkgs.lib.nixosSystem {
              inherit system;
              modules = [
                home-manager.nixosModules.home-manager
                (
                  { pkgs, ... }:
                  {
                    system.stateVersion = "23.11";

                    services.getty.autologinUser = "neovim";

                    virtualisation.vmVariant = {
                      virtualisation = {
                        graphics = false;
                      };
                    };

                    users.groups.neovim = { };
                    users.users.neovim = {
                      initialPassword = "example";
                      isNormalUser = true;
                      group = "neovim";
                      extraGroups = [ "wheel" ];
                    };

                    security.sudo = {
                      enable = true;
                      extraRules = [
                        {
                          users = [ "neovim" ];
                          commands = [
                            {
                              command = "/run/current-system/sw/bin/shutdown";
                              options = [ "NOPASSWD" ];
                            }
                          ];
                        }
                      ];
                    };

                    environment.systemPackages = [
                      pkgs.git
                      pkgs.sumneko-lua-language-server
                    ];

                    home-manager = {
                      useGlobalPkgs = true;
                      useUserPackages = true;

                      users.neovim =
                        { ... }:
                        {
                          imports = [ self.nixosModules.home-manager.neovim-config ];

                          config = {
                            home = {
                              homeDirectory = "/home/neovim";
                              stateVersion = "23.11";
                            };

                            programs.bash = {
                              enable = true;
                              bashrcExtra = ''
                                ${self.packages.${system}.resize-tty}/bin/resize-tty
                              '';
                            };
                          };
                        };
                    };
                  }
                )
              ];
            };
          };

        devShells.default = pkgs.mkShell {
          nativeBuildInputs =
            with pkgs;
            pkgs.lib.optional stdenv.isLinux nixos-rebuild
            ++ [
              lua-language-server
              nixfmt-rfc-style
            ];
        };

        formatter = nixpkgs.legacyPackages.${system}.nixfmt-tree;
      }
    )
    // {
      nixosModules.home-manager.neovim-config = import ./home-manager;
    };
}
