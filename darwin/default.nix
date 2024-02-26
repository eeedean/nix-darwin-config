{ lib, inputs, nixpkgs, home-manager, nix-darwin, user, hostname, ...}:

let
  # Darwin Architecture
  # System Options: [ "aarch64-darwin" "x86_64-darwin" ]
  system = "aarch64-darwin";
in
{
  # MacBook Pro
  "${hostname}" = nix-darwin.lib.darwinSystem {
    inherit system;
    specialArgs = { inherit inputs user hostname; };
    modules = [
      # MacBook Pro Configuration
      ./configuration.nix

      # Home Manager
      home-manager.darwinModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit user; };
        home-manager.users.${user} = {
          imports = [(import ./home.nix)] ++
                    [(import ../modules/home-manager/direnv.nix)] ++
                    [(import ../modules/home-manager/git.nix)] ++
                    [(import ../modules/home-manager/vscode.nix)] ++
                    [(import ../modules/home-manager/nvim.nix)] ++
                    [(import ../modules/home-manager/zsh.nix)];
        };
      }
    ];
  };
}
