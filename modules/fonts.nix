{
  config,
  lib,
  pkgs,
  ...
}: {
  # Fonts
  # https://search.nixos.org/options?channel=unstable&show=fonts
  fonts = {
    # Font Packages
    # https://search.nixos.org/options?channel=unstable&show=fonts.fonts
    packages = with pkgs; [
      dejavu_fonts
      fira-code-symbols
      hack-font
      inconsolata
      inter
      iosevka
      liberation_ttf
      montserrat
      nerdfonts
      noto-fonts
      noto-fonts-emoji
      open-dyslexic
      open-sans
      roboto
      roboto-mono
      source-sans
      source-serif
    ];
  };
}
