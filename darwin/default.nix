{
  lib,
  inputs,
  nixpkgs,
  home-manager,
  nix-darwin,
  user,
  hostname,
  agenix,
  ...
}: let
  # Darwin Architecture
  # System Options: [ "aarch64-darwin" "x86_64-darwin" ]
  system = "aarch64-darwin";
in {
  # MacBook Pro
  "${hostname}" = nix-darwin.lib.darwinSystem {
    inherit system;
    specialArgs = {
      inherit inputs system user hostname agenix;
      nixneovim = inputs.nixneovim;
    };
    modules = [
      {
        nixpkgs = {
          overlays = [
            inputs.nixneovim.overlays.default
          ];
        };
      }
      # MacBook Pro Configuration
      ./configuration.nix

      agenix.nixosModules.default

      # Home Manager
      home-manager.darwinModules.home-manager
    ];
  };
}
