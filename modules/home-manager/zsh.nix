{ config, lib, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "macos"
          "docker"
          "docker-compose"
        ];
      };
    initExtra = ''
      source ~/.profile
    '';
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];
  };
}
