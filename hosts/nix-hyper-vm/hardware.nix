{
  config,
  modulesPath,
  pkgs,
  lib,
  hostname,
  user,
  ...
}: {
  imports = [
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.availableKernelModules = [
    "ata_piix"
    "mptspi"
    "uhci_hcd"
    "ehci_pci"
    "sd_mod"
    "sr_mod"
  ];
  boot.initrd.kernelModules = [
    "hv_vmbus"
    "hv_netvsc"
    "hv_utils"
    "hv_storvsc"
  ];
  boot.kernelModules = [];
  boot.extraModulePackages = [];
  boot.kernelParams = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/40b56b6a-6f83-4435-85e5-db9e1fcf75d5";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/206D-157C";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
  };

  swapDevices = [];

  networking = {
    networkmanager.enable = true;
    hostName = hostname;
    useDHCP = lib.mkDefault true;
  };
  # networking.interfaces.eth0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  virtualisation.hypervGuest.enable = true;
  virtualisation.hypervGuest.videoMode = "1280x720";

  users.users.gdm.extraGroups = ["video"];

  services.libinput.enable = true;

  hardware.pulseaudio.enable = false;
  sound.enable = false;
}
