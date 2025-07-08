{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
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
      in
      {
        packages.resize-tty = pkgs.writeShellScriptBin "resize-tty" ''
          echo -ne '\e[s\e[5000;5000H'
          IFS='[;' read -p $'\e[6n' -d R -a pos -rs
          echo -ne '\e[u'

          ${pkgs.coreutils-full}/bin/stty cols "''${pos[2]}" rows "''${pos[1]}"

          export TERM=xterm-256color
        '';

        packages.nixosConfigurations.vm = nixpkgs.lib.nixosSystem {
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

        devShell = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            nixos-rebuild
            sumneko-lua-language-server
          ];
        };

        formatter = nixpkgs.legacyPackages.${system}.alejandra;
      }
    )
    // {
      nixosModules.home-manager.neovim-config = import ./home-manager;
    };
}
