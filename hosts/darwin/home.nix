{
  config,
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

    homeDirectory = "/Users/${user}";

    file."Library/Application\ Support/xbar/plugins/bahninfo.5s.sh".source = ./xbar/bahninfo.5s.sh;
    file."Library/Application\ Support/xbar/plugins/CalendarLite.1m.sh".source = ./xbar/CalendarLite.1m.sh;
    file.".config/zsh/p10k.zsh".source = ../../modules/home-manager/zsh/.p10k.zsh;
    file.".config/zed/settings.json".source = ../../modules/zed/settings.json;

    packages = with pkgs; [];

    sessionVariables = {
      EDITOR = "vim";
      DOCKER_HOST = "unix://\${HOME}/.colima/default/docker.sock";
      TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE = "/var/run/docker.sock";
      PATH = "$PATH:$HOME/Applications:/opt/homebrew/bin";
    };

    shellAliases = {
      "vsc" = "code";
      "formatjson" = "python -m json.tool";
      "brewupdate" = "brew update && brew upgrade && brew upgrade --cask && brew cleanup";
      "listening-apps" = "lsof -nP -i | grep LISTEN";
      "ls" = "eza";
      "vi" = "nvim";
      "vim" = "nvim";
    };

    activation = {
      setHostName = lib.hm.dag.entryAfter ["writeBoundary"] ''
        if [ "$(/bin/hostname)" != "${hostname}.local" ]; then
          /usr/sbin/scutil --set HostName "${hostname}.local"
        fi
      '';
      ownSecrets = lib.hm.dag.entryAfter ["writeBoundary"] ''
        /usr/bin/sudo chown ${user} /run/agenix/*
        /usr/bin/sudo cp ${age.secrets.id_rsa.path} /Users/${user}/.ssh/id_rsa
        /usr/bin/sudo cp ${age.secrets.id_rsa_pub.path} /Users/${user}/.ssh/id_rsa.pub
        /usr/bin/sudo chown ${user} /Users/${user}/.ssh/id_rsa.pub /Users/${user}/.ssh/id_rsa
      '';

      # This should be removed once
      # https://github.com/nix-community/home-manager/issues/1341 is closed.
      aliasApplications = lib.hm.dag.entryAfter ["writeBoundary"] ''
        #set -o xtrace
        app_folder="$(echo ~/Applications)/Home Manager Apps"
        home_manager_app_folder="$genProfilePath/home-path/Applications"
        $DRY_RUN_CMD rm -rf "$app_folder"
        # NB: aliasing ".../home-path/Applications" to "~/Applications/Home Manager Apps" doesn't
        #     work (presumably because the individual apps are symlinked in that directory, not
        #     aliased). So this makes "Home Manager Apps" a normal directory and then aliases each
        #     application into there directly from its location in the nix store.
        $DRY_RUN_CMD mkdir -p "$app_folder"
        find "$newGenPath/home-path/Applications/" -maxdepth 1 -mindepth 1 | while read app;
        do
          appname=$(find "$app" -maxdepth 0 -printf "%f\n")
          $DRY_RUN_CMD /usr/bin/osascript \
            -e "tell app \"Finder\"" \
            -e "make new alias file at POSIX file \"$app_folder\" to POSIX file \"$app\"" \
            -e "set name of result to \"$appname\"" \
            -e "end tell"
        done
      '';
    };
  };

  programs = {
    home-manager.enable = true;
  };
  disabledModules = ["targets/darwin/linkapps.nix"]; # to use my aliasing instead
}
