{
  config,
  pkgs,
  system,
  user,
  hostname,
  agenix,
  nixneovim,
  ...
}: {
  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina

  # Imports
  imports = [
    ../../modules/fonts.nix
    ../../modules/age.nix
    ../../modules/system-packages.nix
    ./homebrew
  ];

  # MacOS User & Shell
  users.users."${user}" = {
    home = "/Users/${user}";
  };

  users.groups."keys".members = [user];

  # Time Zone (TZ)
  time.timeZone = "Europe/Berlin";

  # Networking
  networking = {
    computerName = "${hostname}";
  };

  # Environment Configuration
  environment = {
    # Installed Nix Packages
    systemPackages = [agenix.packages.${system}.default pkgs.cocoapods pkgs.lmstudio ];
    etc."pam.d/sudo_local".text = ''
      auth       optional       ${pkgs.pam-reattach}/lib/pam/pam_reattach.so # reattach for tmux
      auth       sufficient     pam_tid.so                                   # allow Touch ID for sudo
    '';
    variables = {
      NETRC = "/etc/nix/netrc";
    };
  };

  # System Services
  # https://mynixos.com/nix-darwin/option/services
  services = {

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
    package = pkgs.nixVersions.nix_2_24;
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
      # disabled, because some buggy behaviour: https://github.com/NixOS/nix/issues/7273
      auto-optimise-store = false;

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
        "configurable-impure-env"
      ];

      system-features = [
        "nixos-test"
        "apple-virt"
	"big-parallel"
      ];
    };
    extraOptions = ''
      extra-platforms = x86_64-darwin aarch64-darwin
      extra-sandbox-paths = /etc/nix
      netrc-file = /etc/nix/netrc
      impure-env = NETRC=/etc/nix/netrc
    '';
    # Enable building Linux binaries
    linux-builder = {
      enable = true;
      ephemeral = true;
      maxJobs = 8;
      config = {
        nix.settings.sandbox = false;
        networking = {
          nameservers = ["8.8.8.8" "1.1.1.1"];
        };
        virtualisation = {
          darwin-builder = {
            diskSize = 40 * 1024;
            memorySize = 8 * 1024;
          };
          cores = 8;
          msize = 128 * 1024;
        };
      };
    };
  };

  nixpkgs = {
    # Allow proprietary software
    config.allowUnfree = true;
  };

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
        ShowPathbar = true; # Show breadcrumbs
      };
    };

    # System Version
    stateVersion = 4;
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = {
    inherit user hostname nixneovim system;
    age = config.age;
  };
  home-manager.users.${user} = {
    imports = [
      ./home.nix
      ../../modules/home-manager/direnv.nix
      ../../modules/home-manager/git.nix
      ../../modules/home-manager/vscode.nix
      ../../modules/home-manager/nixneovim.nix
      ../../modules/home-manager/tmux.nix
      ../../modules/home-manager/zsh/zsh.nix
      ../../modules/home-manager/wezterm/wezterm.nix
      ../../modules/home-manager/kitty
    ];
  };
}
