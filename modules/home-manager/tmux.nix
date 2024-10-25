{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    mouse = true;
    sensibleOnTop = false;
    terminal = "tmux-256color";
    historyLimit = 100000;
    plugins = with pkgs; [
      tmuxPlugins.dracula
      tmuxPlugins.better-mouse-mode
    ];
    extraConfig = ''
    '';
  };
}
