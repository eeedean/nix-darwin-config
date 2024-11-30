{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.kitty = {
    enable = true;
    themeFile = "tokyo_night_night";

    font = {
      name = "FiraCode Nerd Font";
      package = pkgs.nerd-fonts.fira-code;
      size = 14;
    };

    keybindings =
      {
        "shift+cmd+t" = "new_tab_with_cwd";
        "cmd+1" = "goto_tab 1";
        "cmd+2" = "goto_tab 2";
        "cmd+3" = "goto_tab 3";
        "cmd+4" = "goto_tab 4";
        "cmd+5" = "goto_tab 5";
        "cmd+6" = "goto_tab 6";
        "cmd+7" = "goto_tab 7";
        "cmd+8" = "goto_tab 8";
        "cmd+9" = "goto_tab 9";
      };

    settings = {
      remember_window_size = true;
      window_passing_width = "0";
      window_margin_width = "0";
      single_window_margin_width = "-1";

      draw_minimal_borders = true;
      hide_window_decorations = true;
      background_opacity = "0.9";
      tab_bar_edge = "top";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";

      enable_audio_bell = false;
      visual_bell_duration = "0.3";

      macos_option_as_alt = "left";
      macos_quit_when_last_window_closed = true;
    };
  };
}
