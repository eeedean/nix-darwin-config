{
  lib,
  inputs,
  nixpkgs,
  my-nixpkgs,
  home-manager,
  nix-darwin,
  user,
  hostname,
  agenix,
  ...
}: let
  system = "aarch64-darwin";
in {
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
            (final: prev: {
              my-packs = import my-nixpkgs {
                inherit system;
                config.allowUnfree = true;
              };
            })
          ];
        };
      }
      ./configuration.nix

      agenix.nixosModules.default
      home-manager.darwinModules.home-manager
    ];
  };
}
