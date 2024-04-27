{ config, inputs, pkgs, user, lib, hostname, age, nixneovim, ... }:

{
  # Home Manager
  home = {
    # Home State Version
    stateVersion = "23.11";

    # Username
    username = "${user}";

    # Home Directory
    #homeDirectory = "/Users/${user}";

    file.".config/zsh/p10k.zsh".source = ../modules/home-manager/zsh/.p10k.zsh;

    # Home Packages
    packages = with pkgs; [
      awscli2
      coreutils
      eza
      nushell
      wget
      jq
    ];

    # Session Variables
    sessionVariables = {
      EDITOR = "nvim";
    };

    shellAliases = {
      "formatjson" = "python -m json.tool";
      "ls" = "eza";
      "vi" = "nvim";
      "vim" = "nvim";
    };

    activation = {
      ownSecrets = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
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
