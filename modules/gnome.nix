{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./gdm-logo.nix
    ./gnome-background.nix
    ./plymouth-logo.nix
  ];

  services.libinput.enable = true;
  services.xserver = {
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
    enable = true;
    xkb.layout = "de";
  };

  customization = {
    gdm-logo.enable = true;
    gnome-background.enable = true;
    plymouth-logo.enable = true;
  };
  hardware.graphics = {
    # this fixes the "glXChooseVisual failed" bug,
    # context: https://github.com/NixOS/nixpkgs/issues/47932
    enable = true;
    enable32Bit = true;
  };
}
