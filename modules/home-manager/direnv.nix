{ config, lib, pkgs, ... }:

{
  # Direnv
  # https://mipmip.github.io/home-manager-option-search/?programs.direnv
  programs.direnv = {

    # Direnv - Enable
    # https://mipmip.github.io/home-manager-option-search/?programs.direnv.enable
    enable = true;

    # Direnv - Bash Integration
    # https://mipmip.github.io/home-manager-option-search/?programs.direnv.enableBashIntegration
    enableBashIntegration = true;

    # Direnv - ZSH Integration
    # https://mipmip.github.io/home-manager-option-search/?programs.direnv.enableZshIntegration
    enableZshIntegration = true;

    # Direnv - Nix Direnv
    # https://mipmip.github.io/home-manager-option-search/?programs.direnv.nix-direnv.enable
    nix-direnv.enable = true;
  };
}
