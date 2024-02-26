{ config, pkgs, user, lib, ... }:

{
  # Home Manager
  home = {
    # Home State Version
    stateVersion = "23.11";

    # Username
    username = "${user}";

    # Home Directory
    homeDirectory = "/Users/${user}";

    # Home Packages
    packages = with pkgs; [
      awscli2
      coreutils
      nushell
      wget
      jq
    ];

    # Session Variables
    sessionVariables = {
      EDITOR = "vim";
    };

    activation = {
      # This should be removed once
      # https://github.com/nix-community/home-manager/issues/1341 is closed.
      aliasApplications = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      #set -o xtrace
      app_folder="$(echo ~/Applications)/Home Manager Apps"
      home_manager_app_folder="$genProfilePath/home-path/Applications"
      $DRY_RUN_CMD rm -rf "$app_folder"
      # NB: aliasing ".../home-path/Applications" to "~/Applications/Home Manager Apps" doesn't
      #     work (presumably because the individual apps are symlinked in that directory, not
      #     aliased). So this makes "Home Manager Apps" a normal directory and then aliases each
      #     application into there directly from its location in the nix store.
      $DRY_RUN_CMD mkdir "$app_folder"
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

  # Programs
  programs = {

    # Home Manager
    home-manager.enable = true;
  };
  disabledModules = [ "targets/darwin/linkapps.nix" ]; # to use my aliasing instead
}
