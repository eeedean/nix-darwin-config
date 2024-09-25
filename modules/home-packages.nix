{pkgs, ...}: {
  home.packages = with pkgs; [
    coreutils
    eza
    nushell
    wget
    jq
  ];
}
