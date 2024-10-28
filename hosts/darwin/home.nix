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

    packages = with pkgs; [ aldente ];

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
      "gen-mac-addr" = ''hexdump -n5 -e'/5 "32" 5/1 ":%02X"' /dev/random | cut -c 1-'';
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
	new_nix_apps="${config.home.homeDirectory}/Applications/Nix"
        rm -rf "$new_nix_apps"
        mkdir -p "$new_nix_apps"
        find -H -L "$newGenPath/home-path/Applications" -name "*.app" -type d -print | while read -r app; do
          real_app=$(readlink -f "$app")
          app_name=$(basename "$app")
          target_app="$new_nix_apps/$app_name"
          echo "Alias '$real_app' to '$target_app'"
          ${pkgs.mkalias}/bin/mkalias "$real_app" "$target_app"
        done
      '';
    };
  };

  programs = {
    home-manager.enable = true;
  };
  disabledModules = ["targets/darwin/linkapps.nix"]; # to use my aliasing instead
}
