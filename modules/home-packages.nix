{pkgs, ...}: {
  home.packages = with pkgs; [
    awscli2
    coreutils
    eza
    lmstudio
    nushell
    wget
    jq
  ];
}
