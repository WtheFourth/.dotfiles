local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.font = wezterm.font_with_fallback({ "JetBrainsMono Nerd Font Mono", "JetBrainsMono Nerd Font" })
config.font_size = 14.0


config.color_scheme = "Tokyo Night"

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

config.leader = { key = 'a', mods = 'CTRL' }
config.keys = {
  {key="Enter", mods="SHIFT", action=wezterm.action{SendString="\x1b\r"}},
  {key="h", mods="ALT|SHIFT", action = wezterm.action.SplitPane { direction = "Left" }},
  {key="j", mods="ALT|SHIFT", action = wezterm.action.SplitPane { direction = "Down" }},
  {key="k", mods="ALT|SHIFT", action = wezterm.action.SplitPane { direction = "Up" }},
  {key="l", mods="ALT|SHIFT", action = wezterm.action.SplitPane { direction = "Right" }},
  {key="h", mods="ALT", action = wezterm.action.ActivatePaneDirection "Left" },
  {key="j", mods="ALT", action = wezterm.action.ActivatePaneDirection "Down" },
  {key="k", mods="ALT", action = wezterm.action.ActivatePaneDirection "Up" },
  {key="l", mods="ALT", action = wezterm.action.ActivatePaneDirection "Right" },
  {key="q", mods="ALT|SHIFT", action = wezterm.action.CloseCurrentPane { confirm = true }},
  {key="t", mods="ALT|SHIFT", action = wezterm.action.SpawnTab "CurrentPaneDomain" },
  {key="w", mods="ALT|SHIFT", action = wezterm.action.CloseCurrentTab { confirm = true }},
  {key="LeftArrow", mods="ALT", action = wezterm.action.ActivateTabRelative(-1) },
  {key="RightArrow", mods="ALT", action = wezterm.action.ActivateTabRelative(1) },
  {key="h", mods="LEADER", action = wezterm.action.AdjustPaneSize { "Left", 5 } },
  {key="j", mods="LEADER", action = wezterm.action.AdjustPaneSize { "Down", 5 } },
  {key="k", mods="LEADER", action = wezterm.action.AdjustPaneSize { "Up", 5 } },
  {key="l", mods="LEADER", action = wezterm.action.AdjustPaneSize { "Right", 5 } },
}

return config
