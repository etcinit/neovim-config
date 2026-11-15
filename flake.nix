{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-26.05";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
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
          # barbar.nvim is flagged unfree in nixpkgs 26.05 due to the JSON
          # License ("used for Good, not Evil"); allow just that package.
          config.allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [ "barbar.nvim" ];
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

        # As of home-manager 26.05, plugins are installed to the data-dir
        # packpath (~/.local/share/nvim/site/pack/hm) and the finalPackage
        # wrapper no longer bakes them in -- they are only discoverable after
        # home-manager activation. `nix run` bypasses activation, so we
        # reconstruct that site directory here and hand it to neovim via
        # 'packpath' below. The runtimePlugin (our src/ bundle) lives in the
        # same pack, so this also makes require('options') etc. resolve.
        packSite = pkgs.linkFarm "nvim-config-site" [
          {
            name = "pack/hm";
            path = hmConfig.config.xdg.dataFile."nvim/site/pack/hm".source;
          }
        ];

        # Extract the init.lua that home-manager generates (it contains
        # initLua + all plugin configs). Without this, neovim launches
        # with plugins on rtp but no configuration applied.
        initLua = pkgs.writeText "init.lua" hmConfig.config.xdg.configFile."nvim/init.lua".text;
      in
      {
        packages = {
          resize-tty = pkgs.writeShellScriptBin "resize-tty" ''
            echo -ne '\e[s\e[5000;5000H'
            IFS='[;' read -p $'\e[6n' -d R -a pos -rs
            echo -ne '\e[u'

            ${pkgs.coreutils-full}/bin/stty cols "''${pos[2]}" rows "''${pos[1]}"

            export TERM=xterm-256color
          '';

          neovim = pkgs.writeShellScriptBin "nvim" ''
            exec env NVIM_APPNAME=nvim-config-test ${neovimPackage}/bin/nvim \
              --cmd "set packpath^=${packSite}" -u ${initLua} "$@"
          '';

          default = self.packages.${system}.neovim;
        };

        checks.boot =
          pkgs.runCommand "neovim-boot-check"
            {
              nativeBuildInputs = [
                self.packages.${system}.neovim
                # gitsigns reports an error at setup if git is missing.
                pkgs.git
              ];
            }
            ''
              export HOME=$(mktemp -d)
              cd "$HOME"

              # Open one file per filetype we care about so FileType/BufRead
              # autocmds, ftplugins, and treesitter run too.
              echo 'local x = 1'    > t.lua
              echo '{ }'            > t.nix
              echo '# hi'           > t.md
              echo 'fn main() {}'   > t.rs
              echo 'main = pure ()' > t.hs

              # Neovim exits 0 even when init or a plugin config throws, so
              # treat anything on stderr as a failure.
              timeout 60 nvim --headless t.lua t.nix t.md t.rs t.hs \
                -c 'bufdo edit' -c 'qa!' 2> stderr.log

              if [ -s stderr.log ]; then
                echo "neovim reported errors during startup:"
                cat stderr.log
                exit 1
              fi

              touch $out
            '';

        devShells.default = pkgs.mkShell {
          nativeBuildInputs =
            with pkgs;
            pkgs.lib.optional stdenv.isLinux nixos-rebuild
            ++ [
              lua-language-server
              nixfmt
            ];
        };

        formatter = nixpkgs.legacyPackages.${system}.nixfmt-tree;
      }
    )
    // {
      nixosModules.home-manager.neovim-config = import ./home-manager;

      # Test VM: nixos-rebuild build-vm --flake .#vm
      nixosConfigurations.vm =
        let
          system = "x86_64-linux";
        in
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            home-manager.nixosModules.home-manager
            (
              { pkgs, ... }:
              {
                system.stateVersion = "23.11";

                # This config is only ever built as a VM (where vmVariant
                # supplies the real values), but `nix flake check` evaluates
                # the plain toplevel, which asserts these are set.
                fileSystems."/" = {
                  device = "/dev/disk/by-label/nixos";
                  fsType = "ext4";
                };
                boot.loader.grub.devices = [ "nodev" ];

                # See the allowUnfreePredicate note on the pkgs import above.
                nixpkgs.config.allowUnfreePredicate =
                  pkg: builtins.elem (nixpkgs.lib.getName pkg) [ "barbar.nvim" ];

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
                  pkgs.lua-language-server
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
}
