# It defines all the packages, dependencies and other configuration needed to build the project.
# The main entry point is the flake.nix file, which contains all the necessary information to build and run the project.

{
  # Flake description
  description = "Personal NixOS Configuration";

  # Flake inputs
  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };


    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # Flake outputs
  outputs = inputs @ { self, nixpkgs, home-manager, nix-darwin, ... }:
    let
      user = "edean";
      hostname = "MacBook-Pro-von-Dean-2";
    in
    {
      darwinConfigurations = (
        import ./darwin {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs home-manager user hostname nix-darwin;
        }
      );
      darwinPackages = self.darwinConfigurations.${hostname}.pkgs;
    };
}
