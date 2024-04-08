{ config, pkgs, system, user, hostname, agenix, nixneovim, ... }:

{
  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina

  # Imports
  imports = [
    (import ../modules/fonts.nix)
    (import ../modules/age.nix)
  ];

  # MacOS User & Shell
  users.users."${user}" = {
    home = "/Users/${user}";
  };

  users.groups."keys".members = [ user ];

  # Time Zone (TZ)
  time.timeZone = "Europe/Berlin";

  # Networking
  networking = {
    computerName = "${hostname}";
  };

  # Environment Configuration
  environment = {

    # Installed Nix Packages
    systemPackages = with pkgs; [
      agenix.packages.${system}.default
      ansible
      audacity
      asciidoctor
      awscli
      bash-completion
      bat
      bun
      cocoapods
      colima
      curl
      diff-so-fancy
      docker-client
      dog
      ffmpeg
      git
      gnupg
      hexedit
      hexyl
      htop
      imagemagick
      inetutils
      jq
      k9s
      kompose
      kubectl
      kubelogin
      kubeseal
      lame
      mysql-client
      nix-direnv
      nmap
      nil
      nyancat
      openjdk17
      pkg-config
      qemu
      ripgrep
      ripmime
      rtmpdump
      s5cmd
      screen
      speedtest-cli
      ssh-copy-id
      tldr
      tree
      velero
      watch
      wget
      xmlstarlet
      zsh-powerlevel10k
    ];
  };

  # System Services
  # https://mynixos.com/nix-darwin/option/services
  services = {
    # Activate System
    # https://mynixos.com/nix-darwin/option/services.activate-system.enable
    activate-system.enable = true;

    # Nix Deamon
    # https://mynixos.com/nix-darwin/option/services.nix-daemon.enable
    nix-daemon = {
      enable = true;
      logFile = "/var/log/nix-daemon.log";
    };
  };

  # Nix Package Manager
  # https://mynixos.com/nix-darwin/option/nix
  nix = {

    # Nix - GC (Garbage Collection)
    # https://mynixos.com/nix-darwin/option/nix.gc
    gc = {

      # Nix - GC - Automatic Garbage Collection
      # https://mynixos.com/nix-darwin/option/nix.gc.automatic
      automatic = true;

      # Nix - GC
      # https://mynixos.com/nix-darwin/option/nix.gc.interval
      interval.Day = 7; #Hours, minutes
      options = "--delete-older-than 7d";
    };

    # Nix - Settings
    # https://mynixos.com/nix-darwin/option/nix.settings
    settings = {
      # Nix - Settings - Optimise Store
      # https://mynixos.com/nix-darwin/option/nix.settings.auto-optimise-store
      auto-optimise-store = true;

      # Nix - Settings - Trusted Users
      # https://mynixos.com/nix-darwin/option/nix.settings.trusted-users
      trusted-users = [
        "${user}"
      ];

      # Nix - Settings - Experimental Features
      # https://mynixos.com/nix-darwin/option/nix.settings.
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      system-features = [
          "nixos-test"
          "apple-virt"
        ];
    };
    extraOptions = ''
      extra-platforms = x86_64-darwin aarch64-darwin
    '';
    # Enable building Linux binaries
    linux-builder = {
        enable = true;
        ephemeral = true;
        maxJobs = 4;
        config = {
          nix.settings.sandbox = false;
          networking = {
            nameservers = [ "8.8.8.8" "1.1.1.1" ];
          };
          virtualisation = {
            darwin-builder = {
              diskSize = 40 * 1024;
              memorySize = 8 * 1024;
            };
            cores = 6;
            msize = 128 * 1024;
          };
        };
      };
  };

  nixpkgs = {
    # Allow proprietary software
    config.allowUnfree = true;
  };

  # Security
  # https://mynixos.com/nix-darwin/option/security.pam.enableSudoTouchIdAuth
  security.pam.enableSudoTouchIdAuth = true;

  system = {
    configurationRevision = config.rev or config.dirtyRev or null;
    defaults = {
      ".GlobalPreferences"."com.apple.mouse.scaling" = -1.0;
      loginwindow.GuestEnabled = false;
      screensaver = {
      askForPassword = true;
      askForPasswordDelay = 5;
      };
      screencapture.location = "~/Pictures/Screenshots";
      NSGlobalDomain = {
        AppleInterfaceStyle = "Dark";
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        # enable "tap to click"
        "com.apple.mouse.tapBehavior" = 1;
      };
      dock = {
        autohide = false;
        orientation = "left";
        magnification = true;
        largesize = 16;
        # Start Screen Saver in top left corner
        wvous-tl-corner = 5;
      };
      finder = {
        ShowPathbar = true;               # Show breadcrumbs
      };
    };

    # System Version
    stateVersion = 4;
  };

  homebrew = {
    enable = true;
    onActivation.upgrade = true;
    brews = [
      "rename" "helm"
    ];
    casks = [
      "android-platform-tools" "anki" "anydesk" "audacity" "background-music" "balenaetcher" "cameracontroller" "coconutbattery" "cryptomator" "cyberduck" "datweatherdoe" "dbvisualizer" "discord" "dozer" "elgato-camera-hub" "elgato-control-center" "elgato-stream-deck" "epoccam" "firefox" "gimp" "glance" "google-chrome" "handbrake" "iterm2" "jdownloader" "jetbrains-toolbox" "keka" "libndi" "macfuse" "macpass" "mactex" "minecraft" "miniconda" "monitorcontrol" "mysqlworkbench" "notion" "obs" "obs-ndi" "paintbrush" "parallels" "portfolioperformance" "powershell" "rectangle" "sensiblesidebuttons" "setapp" "shotcut" "signal" "skype" "slack" "sourcetree" "spotify" "stats" "steam" "telegram" "timeular" "tunnelblick" "ultimaker-cura" "utm" "vlc" "visualvm" "whatsapp" "whisky" "wireshark" "wkhtmltopdf" "xbar" "yubico-yubikey-manager" "zed"
    ];
  };
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = { inherit user hostname nixneovim; age=config.age; };
  home-manager.users.${user} = {
    imports = [
      ./home.nix
      ../modules/home-manager/direnv.nix
      ../modules/home-manager/git.nix
      ../modules/home-manager/vscode.nix
      ../modules/home-manager/nixneovim.nix
      ../modules/home-manager/zsh/zsh.nix
      ../modules/home-manager/wezterm/wezterm.nix
    ];
  };
}
