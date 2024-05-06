{ config, lib, pkgs, ... }:
{
  homebrew = {
    enable = true;
    onActivation.upgrade = true;
    brews = import ./formulae.nix;
    casks = import ./casks.nix;
  };
}