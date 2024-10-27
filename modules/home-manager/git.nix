{
  config,
  lib,
  pkgs,
  user,
  ...
}: {
  home.file.".ssh/allowed_signers".text = "* ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOoOK2BxZdNrWgli6jnYOdlgl6o8rjk7N9FDFo3rfU3m dean.eckert@red-oak-consulting.com";
  # GIT
  # https://mipmip.github.io/home-manager-option-search/?programs.git
  programs.git = {
    # GIT - Enable
    # https://mipmip.github.io/home-manager-option-search/?programs.git.enable
    enable = true;

    # GIT - User Name
    # https://mipmip.github.io/home-manager-option-search/?programs.git.userName
    userName = "Dean Eckert";

    # GIT - User Email
    # https://mipmip.github.io/home-manager-option-search/?programs.git.userEmail
    userEmail = "dean.eckert@red-oak-consulting.com";

    # GIT - Package
    # https://mipmip.github.io/home-manager-option-search/?programs.git.package
    package = pkgs.git;

    # GIT - GPG Signing
    # https://mipmip.github.io/home-manager-option-search/?programs.git.signing
    # signing = {

    # GIT - GPG Signing Key Fingerprint
    # https://mipmip.github.io/home-manager-option-search/?programs.git.signing.key
    # key = "5B60 D309 E35C A3DD 6E9D 74D6 5242 BEFA DE97 4552";

    # GIT - GPG Signing By Default
    # https://mipmip.github.io/home-manager-option-search/?programs.git.signing.signByDefault
    # signByDefault = true;
    # };

    extraConfig = {
      # Sign all commits using ssh key
      commit.gpgsign = true;
      gpg.format = "ssh";
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
      user.signingkey = "~/.ssh/id_ed25519.pub";
      init.defaultBranch = "main";
      signing.signByDefault = true;
    };

    # GIT - Default Ignores
    # https://mipmip.github.io/home-manager-option-search/?programs.git.ignores
    ignores = [
      ".DS_Store"
      ".idea"
      ".direnv"
      ".devenv"
    ];
  };
}
