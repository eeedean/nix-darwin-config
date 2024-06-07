{
  description = "Personal NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    my-nixpkgs.url = "github:eeedean/nixpkgs?ref=my-packs";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixneovim.url = "github:nixneovim/nixneovim";
    agenix.url = "github:ryantm/agenix";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    my-nixpkgs,
    home-manager,
    nix-darwin,
    agenix,
    nixneovim,
    nixos-wsl,
    ...
  }: let
    user = "edean";
    hostname = "MBP-von-Dean";
    forAllSystems = function:
      nixpkgs.lib.genAttrs ["aarch64-darwin" "x86_64-darwin" "aarch64-linux" "x86_64-linux"] (system:
        function {
          inherit system;
          pkgs = nixpkgs.legacyPackages.${system};
        });
  in {
    darwinConfigurations = (
      import ./hosts/darwin {
        inherit (nixpkgs) lib;
        inherit inputs nixpkgs home-manager user hostname nix-darwin agenix;
      }
    );

    nixosConfigurations.wsl = (
      import ./hosts/wsl/default.nix {
        inherit (nixpkgs) lib;
        inherit inputs nixpkgs home-manager agenix nixos-wsl;
      }
    );
    nixosConfigurations.karotte = (
      import ./hosts/karotte/default.nix {
        inherit (nixpkgs) lib;
        inherit inputs nixpkgs home-manager agenix;
      }
    );
    nixosConfigurations."NiXPS" = let
      system = "x86_64-linux";
    in
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs system;
          user = "dean";
          hostname = "NiXPS";
        };
        modules = [
          ./hosts/nixps
          home-manager.nixosModules.home-manager
        ];
      };
    formatter = forAllSystems ({pkgs, ...}: pkgs.alejandra);
  };
}
