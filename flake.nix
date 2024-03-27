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
    agenix.url = "github:ryantm/agenix";
  };

  outputs = inputs @ { self, nixpkgs, home-manager, nix-darwin, agenix, ... }:
    let
      user = inputs.user;
      hostname = inputs.hostname;
    in
    {
      darwinConfigurations = (
        import ./darwin {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs home-manager user hostname nix-darwin agenix;
        }
      );
      darwinPackages = self.darwinConfigurations.${hostname}.pkgs;
    };
}
