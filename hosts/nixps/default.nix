{
  config,
  lib,
  pkgs,
  inputs,
  user,
  hostname,
  ...
}: {
  imports = [
    {
      nixpkgs = {
        overlays = [
          inputs.nixneovim.overlays.default
        ];
      };
    }
    ./hardware.nix
    ./configuration.nix
    ../../modules/gnome.nix
    ../../modules/age.nix
    inputs.agenix.nixosModules.default
    inputs.home-manager.nixosModules.home-manager
  ];
  system.stateVersion = "24.05";
  nixpkgs.config.allowUnfree = true;
}
