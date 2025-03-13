local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.color_scheme = "Tokyo Night"

config.window_frame = {}

config.font = wezterm.font_with_fallback({ "FiraCode Nerd Font Mono", "Fira Code" })
config.font_size = 14.0

config.use_fancy_tab_bar = false

config.colors = {
  tab_bar = {
    background = "#1e1e2e",
    active_tab = {
      fg_color = "#cdd6f4",
      bg_color = "#1e1e2e",
    },
    inactive_tab = {
      bg_color = "#585b70",
      fg_color = "#cdd6f4",
    },
    inactive_tab_hover = {
      bg_color = "#8c8ea5",
      fg_color = "#cdd6f4",
    },
  },
}

return config
