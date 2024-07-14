{
  config,
  pkgs,
  ...
}: {
  imports = [
  ];

  services.xserver.enable = true;
  services.xserver.xkb.layout = "de";

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.defaultSession = "plasmax11";
  hardware.graphics = {
    # this fixes the "glXChooseVisual failed" bug,
    # context: https://github.com/NixOS/nixpkgs/issues/47932
    enable = true;
    enable32Bit = true;
  };
}