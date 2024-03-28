{ config, lib, pkgs, ... }:

{
  #file.".p10k.zsh".source = ./.p10k.zsh;

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    dotDir = ".config/zsh";
    history = {
      size = 99999;
      save = 99999;
    };
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
      source ~/.secure_profile
      source ~/.config/zsh/p10k.zsh
      export PATH="$PATH:/opt/homebrew/bin";
      function saytofile(){ say -v $1 $2 -o .tmp.aiff && lame -m m .tmp.aiff $3.mp3 && rm .tmp.aiff; };
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
