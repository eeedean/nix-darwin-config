local wezterm = require("wezterm")
local act = wezterm.action

local config = {}
-- Use config builder object if possible
if wezterm.config_builder then config = wezterm.config_builder() end

-- Settings
config.color_scheme = "Tokyo Night"
-- config.front_end = "WebGpu";
config.front_end = "OpenGL";
-- config.color_scheme = "gotham"
config.window_background_opacity = 0.9
config.window_decorations = "RESIZE"
config.window_close_confirmation = "AlwaysPrompt"
config.scrollback_lines = 3000
config.default_workspace = "home"
config.initial_cols = 175
config.initial_rows = 50
config.font_size = 14
config.send_composed_key_when_left_alt_is_pressed = true
config.send_composed_key_when_right_alt_is_pressed = true
config.use_ime = false


-- Dim inactive panes
config.inactive_pane_hsb = {
  saturation = 1.24,
  brightness = 0.5
}

-- Keys
config.leader = { key = "w", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
  -- { key = '8', mods = 'ALT', action = "SendString", arg = "{" },
  -- Send C-a when pressing C-a twice
  { key = "w",          mods = "LEADER", action = act.SendKey { key = "w", mods = "CTRL" } },
  { key = "c",          mods = "LEADER", action = act.ActivateCopyMode },

  -- Pane keybindings
  { key = "-",          mods = "LEADER", action = act.SplitVertical { domain = "CurrentPaneDomain" } },
  -- SHIFT is for when caps lock is on
  { key = "s",          mods = "LEADER", action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },
  { key = "LeftArrow",  mods = "LEADER", action = act.ActivatePaneDirection("Left") },
  { key = "DownArrow",  mods = "LEADER", action = act.ActivatePaneDirection("Down") },
  { key = "UpArrow",    mods = "LEADER", action = act.ActivatePaneDirection("Up") },
  { key = "RightArrow", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
  { key = "x",          mods = "LEADER", action = act.CloseCurrentPane { confirm = true } },
  { key = "z",          mods = "LEADER", action = act.TogglePaneZoomState },
  -- We can make separate keybindings for resizing panes
  -- But Wezterm offers custom "mode" in the name of "KeyTable"
  { key = "r",          mods = "LEADER", action = act.ActivateKeyTable { name = "resize_pane", one_shot = false } },

  -- Tab keybindings
  { key = "n",          mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
  { key = "[",          mods = "LEADER", action = act.ActivateTabRelative(-1) },
  { key = "]",          mods = "LEADER", action = act.ActivateTabRelative(1) },
  { key = "t",          mods = "LEADER", action = act.ShowTabNavigator },
  -- Key table for moving tabs around
  { key = "m",          mods = "LEADER", action = act.ActivateKeyTable { name = "move_tab", one_shot = false } },


  -- Lastly, workspace
  { key = "w",          mods = "LEADER", action = act.ShowLauncherArgs { flags = "FUZZY|WORKSPACES" } },


  -- Make Option-Right equivalent to Alt-f; forward-word
  { key = "RightArrow", mods = "OPT",    action = wezterm.action { SendString = "\x1bf" } },
  -- Make Option-Left equivalent to Alt-b which many line editors interpret as backward-word
  { key = "LeftArrow",  mods = "OPT",    action = wezterm.action { SendString = "\x1bb" } },
  { key = "+",          mods = "CMD",    action = wezterm.action.IncreaseFontSize },
  { key = "-",          mods = "CMD",    action = wezterm.action.DecreaseFontSize },

}
-- I can use the tab navigator (LDR t), but I also want to quickly navigate tabs with index
for i = 1, 9 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = "LEADER",
    action = act.ActivateTab(i - 1)
  })
end

config.key_tables = {
  resize_pane = {
    { key = "h",      action = act.AdjustPaneSize { "Left", 1 } },
    { key = "j",      action = act.AdjustPaneSize { "Down", 1 } },
    { key = "k",      action = act.AdjustPaneSize { "Up", 1 } },
    { key = "l",      action = act.AdjustPaneSize { "Right", 1 } },
    { key = "Escape", action = "PopKeyTable" },
    { key = "Enter",  action = "PopKeyTable" },
  },
  move_tab = {
    { key = "h",      action = act.MoveTabRelative(-1) },
    { key = "j",      action = act.MoveTabRelative(-1) },
    { key = "k",      action = act.MoveTabRelative(1) },
    { key = "l",      action = act.MoveTabRelative(1) },
    { key = "Escape", action = "PopKeyTable" },
    { key = "Enter",  action = "PopKeyTable" },
  }
}

-- Tab bar
-- I don't like the look of "fancy" tab bar
config.use_fancy_tab_bar = false
config.status_update_interval = 1000
wezterm.on("update-right-status", function(window, pane)
  -- Workspace name
  local stat = window:active_workspace()
  -- It's a little silly to have workspace name all the time
  -- Utilize this to display LDR or current key table name
  if window:active_key_table() then stat = window:active_key_table() end
  if window:leader_is_active() then stat = "LDR" end

  -- Current working directory
  local basename = function(s)
    -- Nothign a little regex can't fix
    return string.gsub(s, "(.*[/\\])(.*)", "%2")
  end
  local cwd = basename(pane:get_current_working_dir())
  -- Current command
  local cmd = basename(pane:get_foreground_process_name())

  -- Time
  local time = wezterm.strftime("%H:%M")

  -- Let's add color to one of the components
  window:set_right_status(wezterm.format({
    -- Wezterm has a built-in nerd fonts
    { Text = wezterm.nerdfonts.oct_table .. "  " .. stat },
    { Text = " | " },
    { Text = wezterm.nerdfonts.md_folder .. "  " .. cwd },
    { Text = " | " },
    { Foreground = { Color = "FFB86C" } },
    { Text = wezterm.nerdfonts.fa_code .. "  " .. cmd },
    "ResetAttributes",
    { Text = " | " },
    { Text = wezterm.nerdfonts.md_clock .. "  " .. time },
    { Text = " |" },
  }))
end)

return config
