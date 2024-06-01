{
  config,
  pkgs,
  inputs,
  system,
  user,
  hostname,
  ...
}: {
  imports = [
    ../../modules/fonts.nix
    ../../modules/system-packages.nix
    ../../modules/locale-de.nix
    ../../modules/firewall.nix
    ../../modules/nix-settings.nix
  ];

  nixpkgs.config.allowUnfree = true;

  programs.zsh.enable = true;
  services.openssh.enable = true;

  security.sudo.wheelNeedsPassword = false;

  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
    ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOoOK2BxZdNrWgli6jnYOdlgl6o8rjk7N9FDFo3rfU3m dean.eckert@red-oak-consulting.com"
    ];
    initialPassword = "changeme";
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = {
    inherit user hostname;
    inherit (inputs) nixneovim agenix;
    age = config.age;
  };
  home-manager.users.${user} = {
    imports = [
      ./home.nix
    ];
  };
}
