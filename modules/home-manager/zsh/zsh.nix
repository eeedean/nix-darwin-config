{
  config,
  lib,
  pkgs,
  ...
}: {
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
      source ~/.secure_profile 2> /dev/null
      source ~/.profile 2> /dev/null
      source ~/.config/zsh/p10k.zsh
      function saytofile(){ say -v $1 $2 -o .tmp.aiff && lame -m m .tmp.aiff $3.mp3 && rm .tmp.aiff; };
      function padBinary() {
        if [ -n "$2" ]; then
          printf "%0*d\n" $2 $(echo "obase=2;$1" | bc);
        else
          echo "obase=2;$1" | bc;
        fi
      };
      export NIX_REV="f40efe1ce90f9cd692c8d56d9305fa6b9c07f211";
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
