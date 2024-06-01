{
  config,
  pkgs,
  ...
}: {
  nix = {
    settings = {
      trusted-users = ["@wheel"];
      accept-flake-config = true;
      auto-optimise-store = true;
    };

    extraOptions = ''experimental-features = nix-command flakes'';

    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };
}
