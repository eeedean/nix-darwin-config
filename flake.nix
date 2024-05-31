{
  description = "Personal NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
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
      import ./darwin {
        inherit (nixpkgs) lib;
        inherit inputs nixpkgs home-manager user hostname nix-darwin agenix;
      }
    );
    darwinPackages = self.darwinConfigurations.${hostname}.pkgs;

    nixosConfigurations.wsl = (
      import ./wsl/default.nix {
        inherit (nixpkgs) lib;
        inherit inputs nixpkgs home-manager agenix nixos-wsl;
      }
    );
    nixosConfigurations.karotte = (
      import ./karotte/default.nix {
        inherit (nixpkgs) lib;
        inherit inputs nixpkgs home-manager agenix;
      }
    );
    formatter = forAllSystems ({pkgs, ...}: pkgs.alejandra);
  };
}
