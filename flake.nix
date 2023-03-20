{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    flake-utils,
    nixpkgs,
    home-manager,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = (import nixpkgs) {
          inherit system;
        };
      in rec {
        packages.nixosConfigurations.vm = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            home-manager.nixosModules.home-manager
            ({pkgs, ...}: {
              system.stateVersion = "22.11";

              virtualisation.vmVariant = {
                virtualisation = {
                  graphics = false;
                };
              };

              users.users.neovim = {
                initialPassword = "example";
                isNormalUser = true;
                group = "neovim";
                extraGroups = ["wheel"];
              };

              environment.systemPackages = [
                pkgs.git
              ];

              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;

                users.neovim = ({...}: {
                  config.home.homeDirectory = "/home/neovim";
                  config.home.stateVersion = "22.11";
                  imports = [self.nixosModules.home-manager.neovim-config];
                });
              };
            })
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


