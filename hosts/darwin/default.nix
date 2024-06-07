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
            inputs.nixneovim.overlays.default
	    (final: prev: {
	      my-packs = my-nixpkgs.legacyPackages.${system};
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
