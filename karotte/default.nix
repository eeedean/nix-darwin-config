{ lib, inputs, nixpkgs, home-manager, agenix, ...}:

let
  system = "x86_64-linux";
  hostname = "karotte";
  user = "dean";
in
nixpkgs.lib.nixosSystem {
  inherit system;
  specialArgs = { inherit inputs system user hostname agenix; nixneovim = inputs.nixneovim; };
  modules = [
    {
      nixpkgs = {
        overlays = [
          inputs.nixneovim.overlays.default
        ];
      };
    }

    ./configuration.nix

    agenix.nixosModules.default
    home-manager.nixosModules.home-manager
  ];
}

