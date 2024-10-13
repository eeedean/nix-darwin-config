{
  config,
  inputs,
  pkgs,
  user,
  lib,
  hostname,
  age,
  nixneovim,
  ...
}: {
  imports = [
    ../../modules/home-packages.nix
  ];
  home = {
    stateVersion = "23.11";

    username = "${user}";
    homeDirectory = "/home/${user}/";

    file.".config/zsh/p10k.zsh".source = ../../modules/home-manager/zsh/.p10k.zsh;


    sessionVariables = {
      EDITOR = "nvim";
    };

    shellAliases = {
      "formatjson" = "python -m json.tool";
      "ls" = "eza";
      "vi" = "nvim";
      "vim" = "nvim";
    };

  };

  programs = {
    # Home Manager
    home-manager.enable = true;
  };
}
