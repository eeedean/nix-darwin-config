{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.kitty = {
    enable = true;
    theme = "Tokyo Night";

    font = {
      name = "FiraCode Nerd Font";
      package = pkgs.nerdfonts;
      size = 14;
    };

    settings = {
      remember_window_size = true;
      window_passing_width = "0";
      window_margin_width = "0";
      single_window_margin_width = "-1";

      draw_minimal_borders = true;
      hide_window_decorations = true;
      background_opacity = "0.9";


      enable_audio_bell = false;
      visual_bell_duration = "0.3";

      macos_option_as_alt = "left";
      macos_quit_when_last_window_closed = true;
    };
  };
}
