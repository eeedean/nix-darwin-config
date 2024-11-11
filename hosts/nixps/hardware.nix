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
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "rtsx_pci_sdmmc"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];
  boot.kernelParams = [ "mem_sleep_default=deep" ];
  boot.loader.systemd-boot.enable = true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Nvidia Configuration
  services.xserver.videoDrivers = ["nvidia"];
  hardware.graphics.enable = true;

  # Optionally, you may need to select the appropriate driver version for your specific GPU.
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  hardware.nvidia.open = false;

  # nvidia-drm.modeset=1 is required for some wayland compositors, e.g. sway
  hardware.nvidia.modesetting.enable = true;

  hardware.nvidia.prime = {
    sync.enable = true;

    # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
    nvidiaBusId = "PCI:1:0:0";

    # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
    intelBusId = "PCI:0:2:0";
  };

  services.logind.lidSwitch = "suspend";
  systemd.sleep.extraConfig = ''
  '';

  networking = {
    networkmanager.enable = true;
    hostName = hostname;
  };

  # doesn't work yet, but maybe it'll be patched at some point? 
  services.fprintd = {
    enable = true;
    package = pkgs.fprintd-tod;
    tod.enable = true;
    tod.driver = pkgs.libfprint-2-tod1-goodix;
  };

  console.earlySetup = true;

  services.fwupd.enable = lib.mkDefault true;

  services.fstrim.enable = lib.mkDefault true;
  services.thermald.enable = lib.mkDefault true;
}
