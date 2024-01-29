{
  description = "My Darwin System Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
  let
    configuration = { pkgs, ... }: {
      nixpkgs.config.allowUnfree = true;
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = with pkgs; [ 
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
        vim
        watch
        wget
        xmlstarlet
        zsh-powerlevel10k
      ];
        
      homebrew = {
        enable = true;
        brews = [
          "rename" "helm" "exa"
        ];
        casks = [
          "android-platform-tools" "anki" "anydesk" "audacity" "background-music" "balenaetcher" "cameracontroller" "coconutbattery" "cryptomator" "cyberduck" "datweatherdoe" "dbvisualizer" "discord" "dozer" "elgato-camera-hub" "elgato-control-center" "elgato-stream-deck" "epoccam" "firefox" "gimp" "glance" "google-chrome" "handbrake" "iterm2" "jdownloader" "jetbrains-toolbox" "keka" "libndi" "macfuse" "macpass" "mactex" "minecraft" "miniconda" "monitorcontrol" "mysqlworkbench" "notion" "obs" "obs-ndi" "paintbrush" "parallels" "portfolioperformance" "powershell" "rectangle" "sensiblesidebuttons" "setapp" "shotcut" "signal" "skype" "slack" "sourcetree" "spotify" "stats" "steam" "telegram" "timeular" "tunnelblick" "ultimaker-cura" "utm" "vlc" "visualvm" "whatsapp" "wireshark" "wkhtmltopdf" "xbar" "yubico-yubikey-manager"
        ];
      };

      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      users.users.edean.home = "/Users/edean";
      home-manager.users.edean = { pkgs, ... }: {
        home.stateVersion = "23.11";
        programs.zsh = {
          enable = true;
          enableAutosuggestions = true;
          oh-my-zsh = {
              enable = true;
              plugins = [
                "git"
                "macos"
                "docker"
                "docker-compose"
              ];
            };
          initExtra = ''
            source ~/.profile
          '';
          plugins = [
            {
              name = "powerlevel10k";
              src = pkgs.zsh-powerlevel10k;
              file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
            }
          ];
        };

        programs.direnv = {
          enable = true;
          nix-direnv.enable = true;
          enableZshIntegration = true;
        };
        programs.vscode = {
          enable = true;
          extensions = with pkgs.vscode-extensions; [
            arrterian.nix-env-selector
            bbenoist.nix
            dotjoshjohnson.xml
            dracula-theme.theme-dracula
            jnoortheen.nix-ide
            mkhl.direnv
            ms-azuretools.vscode-docker
            redhat.java
            scala-lang.scala
            vscjava.vscode-gradle
            vscjava.vscode-java-debug
            vscjava.vscode-java-dependency
            vscjava.vscode-java-test
            vscjava.vscode-maven
            yzhang.markdown-all-in-one
          ];
        };
      };

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      services.nix-daemon.logFile = "/var/log/nix-daemon.log";
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";
      nix.settings.trusted-users = ["edean"];
      nix.gc = {
         automatic = true;
         interval.Day = 7; #Hours, minutes
         options = "--delete-older-than 7d";
      };

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;  # default shell on catalina

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 4;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
      # announce rosetta to nix-darwin
      nix.extraOptions = ''
        extra-platforms = x86_64-darwin aarch64-darwin
      '';
      # Enable building Linux binaries
      nix.linux-builder.enable = true;

      # Enable TouchID for sudo
      security.pam.enableSudoTouchIdAuth = true;
      system.defaults = {
        finder.AppleShowAllExtensions = true;
        screencapture.location = "~/Pictures/Screenshots";
        finder.FXPreferredViewStyle = "Nlsv";
        ".GlobalPreferences"."com.apple.mouse.scaling" = -1.0;
        NSGlobalDomain.AppleInterfaceStyle = "Dark";
        NSGlobalDomain.NSAutomaticCapitalizationEnabled = false;
        # enable "tap to click"
        NSGlobalDomain."com.apple.mouse.tapBehavior" = 1;
        dock.autohide = false;
        dock.magnification = true;
        dock.largesize = 16;
        # Start Screen Saver in top left corner
        dock.wvous-tl-corner = 5;
        # Show breadcrumbs
        finder.ShowPathbar = true;
        loginwindow.GuestEnabled = false;
        screensaver.askForPassword = true;
        screensaver.askForPasswordDelay = 5;
      };
      
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."MacBook-Pro-von-Dean-2" = nix-darwin.lib.darwinSystem {
      modules = [ 
        home-manager.darwinModules.home-manager
        configuration
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."MacBook-Pro-von-Dean-2".pkgs;
  };
}
