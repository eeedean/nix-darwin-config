{
  config,
  pkgs,
  inputs,
  system,
  user,
  hostname,
  ...
}: {
  imports = [
  ];
  virtualisation.docker.enable = true;
  environment.systemPackages = with pkgs; [];
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      ovmf = {
        enable = true;
      };
    };
  };
  users.users.${user} = {
    extraGroups = ["libvirtd" "docker"];
  };
  programs.virt-manager.enable = true;
  programs.dconf.enable = true;
}
