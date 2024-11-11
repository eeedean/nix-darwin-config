{
  description = "Personal NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/b69de56fac8c2b6f8fd27f2eca01dcda8e0a4221";
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
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-anywhere = {
      url = "github:numtide/nixos-anywhere";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.disko.follows = "disko";
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
    homeConfigurations."karotte" = let 
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system}.extend inputs.nixneovim.overlays.default;
    in 
      home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ 
          ./hosts/karotte/home.nix
          ./modules/home-manager/direnv.nix
          ./modules/home-manager/git.nix
          ./modules/home-manager/nixneovim.nix
          ./modules/home-manager/zsh/zsh.nix
          ./modules/home-manager/wezterm/wezterm.nix
        ];

        # Optionally use extraSpecialArgs
        # to pass  through arguments to home.nix
        extraSpecialArgs = {
          inherit system;
          user = "dean";
          nixneovim = inputs.nixneovim;
        };
      };
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
    nixosConfigurations."VirtualNix" = let
      system = "x86_64-linux";
    in
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs system;
          user = "dean";
          hostname = "VirtualNix";
        };
        modules = [
          ./hosts/virtual-nix
          home-manager.nixosModules.home-manager
        ];
      };
    nixosConfigurations."NixHyperVM" = let
      system = "x86_64-linux";
    in
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs system;
          user = "dean";
          hostname = "NixHyperVM";
        };
        modules = [
          ./hosts/nix-hyper-vm
          home-manager.nixosModules.home-manager
        ];
      };
    formatter = forAllSystems ({pkgs, ...}: pkgs.alejandra);
  };
}
