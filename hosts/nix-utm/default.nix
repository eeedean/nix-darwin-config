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
    ./shared-vm.nix
    /*../../modules/gnome.nix*/
    /*../../modules/age.nix*/
    inputs.agenix.nixosModules.default
    inputs.home-manager.nixosModules.home-manager
  ];
  system.stateVersion = "24.11";
  nixpkgs.config.allowUnfree = true;
  services.spice-vdagentd.enable = true;
}
