{
  config,
  pkgs,
  inputs,
  system,
  user,
  hostname,
  agenix,
  nixneovim,
  ...
}: {
  imports = [
    ../../modules/fonts.nix
    ../../modules/age.nix
    ../../modules/system-packages.nix
  ];

  nixpkgs = {
    config.allowUnfree = true;
  };

  time.timeZone = "Europe/Berlin";

  networking.hostName = "${hostname}";

  systemd.tmpfiles.rules = [
    "d /home/${user}/.config 0755 ${user} users"
    "d /home/${user}/.config/lvim 0755 ${user} users"
  ];

  programs.zsh.enable = true;
  environment.pathsToLink = ["/share/zsh"];
  environment.shells = [pkgs.zsh];

  environment.enableAllTerminfo = true;

  security.sudo.wheelNeedsPassword = false;

  services.openssh.enable = true;

  users.users.${user} = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "docker"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOoOK2BxZdNrWgli6jnYOdlgl6o8rjk7N9FDFo3rfU3m dean.eckert@red-oak-consulting.com"
    ];
  };

  environment.systemPackages = [agenix.packages.${system}.default];

  system.stateVersion = "23.11";

  wsl = {
    enable = true;
    wslConf.automount.root = "/mnt";
    wslConf.interop.appendWindowsPath = false;
    wslConf.network.generateHosts = false;
    defaultUser = user;
    startMenuLaunchers = true;

    # Enable integration with Docker Desktop (needs to be installed)
    docker-desktop.enable = false;
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune.enable = true;
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = {
    inherit user hostname system;
    age = config.age;
    nixneovim = inputs.nixneovim;
  };
  home-manager.users.${user} = {
    imports = [
      ./home.nix
      ../../modules/home-manager/direnv.nix
      ../../modules/home-manager/git.nix
      ../../modules/home-manager/nixneovim.nix
      ../../modules/home-manager/zsh/zsh.nix
      ../../modules/home-manager/wezterm/wezterm.nix
    ];
  };

  nix = {
    settings = {
      trusted-users = [user];

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
