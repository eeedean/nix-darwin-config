{pkgs, ...}: {
  home.packages = with pkgs; [
    awscli2
    coreutils
    eza
    nushell
    wget
    jq
  ];
}
