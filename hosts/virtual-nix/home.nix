{
  config,
  lib,
  pkgs,
  inputs,
  user,
  hostname,
  age,
  ...
}: {
  imports = [
    ../../modules/home-packages.nix
    ../../modules/home-manager/direnv.nix
    ../../modules/home-manager/git.nix
    ../../modules/home-manager/vscode.nix
    ../../modules/home-manager/nixneovim.nix
    ../../modules/home-manager/zsh/zsh.nix
    ../../modules/home-manager/tmux.nix
  ];

  home = {
    stateVersion = "23.11";

    username = "${user}";

    file.".config/zsh/p10k.zsh".source = ../../modules/home-manager/zsh/.p10k.zsh;

    packages = with pkgs; [
      discord
      enpass
      firefox
      jetbrains.idea-ultimate
      telegram-desktop
      usbutils
    ];

    # Session Variables
    sessionVariables = {
      EDITOR = "nvim";
      WAYLAND_DISPLAY = "true";
      PATH = "$PATH:${pkgs.jetbrains.idea-ultimate}/idea-ultimate/bin";
    };

    shellAliases = {
      "vsc" = "code";
      "formatjson" = "python -m json.tool";
      "ls" = "eza";
      "vi" = "nvim";
      "vim" = "nvim";
    };

    activation = {
      ownSecrets = lib.hm.dag.entryAfter ["writeBoundary"] ''
        $DRY_RUN_CMD /run/wrappers/bin/sudo chown -R ${user} /run/agenix/
        $DRY_RUN_CMD /run/wrappers/bin/sudo cp ${age.secrets.id_rsa.path} /home/${user}/.ssh/id_rsa
        $DRY_RUN_CMD /run/wrappers/bin/sudo cp ${age.secrets.id_rsa_pub.path} /home/${user}/.ssh/id_rsa.pub
        $DRY_RUN_CMD /run/wrappers/bin/sudo chown ${user} /home/${user}/.ssh/id_rsa.pub /home/${user}/.ssh/id_rsa
      '';
    };
  };

  # Programs
  programs = {
    # Home Manager
    home-manager.enable = true;
  };
}
