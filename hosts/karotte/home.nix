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
  home = {
    stateVersion = "23.11";

    username = "${user}";

    file.".config/zsh/p10k.zsh".source = ../../modules/home-manager/zsh/.p10k.zsh;

    packages = import ../../common/home-packages.nix {inherit pkgs;};

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
      ownSecrets = lib.hm.dag.entryAfter ["writeBoundary"] ''
        $DRY_RUN_CMD /run/wrappers/bin/sudo chown -R ${user} /run/agenix/
        $DRY_RUN_CMD /run/wrappers/bin/sudo cp ${age.secrets.id_rsa.path} /home/${user}/.ssh/id_rsa
        $DRY_RUN_CMD /run/wrappers/bin/sudo cp ${age.secrets.id_rsa_pub.path} /home/${user}/.ssh/id_rsa.pub
        $DRY_RUN_CMD /run/wrappers/bin/sudo chown ${user} /home/${user}/.ssh/id_rsa.pub /home/${user}/.ssh/id_rsa
      '';
    };
  };

  programs = {
    # Home Manager
    home-manager.enable = true;
  };
}
