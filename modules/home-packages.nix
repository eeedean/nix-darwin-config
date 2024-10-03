{pkgs, ...}: {
  home.packages = with pkgs; [
    coreutils
    eza
    nushell
    openshift
    wget
    jq
  ];
}
