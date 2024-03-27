#!/usr/bin/env sh

if [ -z "$1" ]; then
  nixhost="$(hostname -s)"
else
  nixhost="$1"
fi

architecture=$(uname -m)

# Check if the architecture is arm64
if [ "$architecture" = "arm64" ]; then
  sudo softwareupdate --install-rosetta
fi

# Install nix
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

# Install Homebrew
curl -fsSL -o install.sh https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
chmod +x install.sh
./install.sh
rm -fr install.sh
eval "$(/usr/local/bin/brew shellenv)"

nix run nix-darwin -- switch --flake ."#$nixhost"
