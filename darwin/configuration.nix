{ config, pkgs, user, hostname, ... }:

{

  # Imports
  imports = [(import ../modules/fonts.nix)];

  # MacOS User & Shell
  users.users."${user}" = {
    home = "/Users/${user}";
  };

  # Time Zone (TZ)
  time.timeZone = "Europe/Berlin";

  # Networking
  networking = {
    computerName = "${hostname}";
    hostName = "${hostname}";
  };

  # Environment Configuration
  environment = {

    # Installed Nix Packages
    systemPackages = with pkgs; [
      audacity
      asciidoctor
      awscli
      bash-completion
      bat
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
      mysql-client
      nix-direnv
      nmap
      nil
      nyancat
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

    # Nix - Package
    # https://mynixos.com/nix-darwin/option/nix.package
    package = pkgs.nix;

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
    };
    extraOptions = ''
      extra-platforms = x86_64-darwin aarch64-darwin
    '';
    # Enable building Linux binaries
    linux-builder.enable = true;
  };

  # Allow proprietary software
  nixpkgs = {
    config.allowUnfree = true;
  };

  # Security
  # https://mynixos.com/nix-darwin/option/security.pam.enableSudoTouchIdAuth
  security.pam.enableSudoTouchIdAuth = true;

  # DawinOS System Settings
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
      NSGlobalDomain = {                  # Global macOS system settings
        AppleInterfaceStyle = "Dark";
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        # enable "tap to click"
        "com.apple.mouse.tapBehavior" = 1;
      };
      dock = {                            # Dock settings
        autohide = false;
        orientation = "left";
        magnification = true;
        largesize = 16;
        # Start Screen Saver in top left corner
        wvous-tl-corner = 5;
      };
      finder = {                          # Finder settings
        ShowPathbar = true;               # Show breadcrumbs
      };
    };

    # System Version
    stateVersion = 4;
  };

  homebrew = {                            # Declare Homebrew using Nix-Darwin
      enable = true;
      onActivation.upgrade = true;                    # Auto update packages
      brews = [
        "rename" "helm" "exa"
      ];
      casks = [
        "android-platform-tools" "anki" "anydesk" "audacity" "background-music" "balenaetcher" "cameracontroller" "coconutbattery" "cryptomator" "cyberduck" "datweatherdoe" "dbvisualizer" "discord" "dozer" "elgato-camera-hub" "elgato-control-center" "elgato-stream-deck" "epoccam" "firefox" "gimp" "glance" "google-chrome" "handbrake" "iterm2" "jdownloader" "jetbrains-toolbox" "keka" "libndi" "macfuse" "macpass" "mactex" "minecraft" "miniconda" "monitorcontrol" "mysqlworkbench" "notion" "obs" "obs-ndi" "paintbrush" "parallels" "portfolioperformance" "powershell" "rectangle" "sensiblesidebuttons" "setapp" "shotcut" "signal" "skype" "slack" "sourcetree" "spotify" "stats" "steam" "telegram" "timeular" "tunnelblick" "ultimaker-cura" "utm" "vlc" "visualvm" "whatsapp" "wireshark" "wkhtmltopdf" "xbar" "yubico-yubikey-manager" "zed"
      ];
    };
}
