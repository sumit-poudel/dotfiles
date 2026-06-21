local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- ===== Appearance =====
config.color_scheme = "Noctalia"
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.95
config.enable_tab_bar = false

config.window_padding = {
  left = 4,
  right = 4,
  top = 4,
  bottom = 4,
}

-- ===== Font =====
config.font = wezterm.font("Monolisa")
config.font_size = 13.0

-- ===== Cursor =====
config.default_cursor_style = 'BlinkingBlock'
config.cursor_blink_rate = 500

-- ===== Mouse =====
config.hide_mouse_cursor_when_typing = true

-- ===== Scrolling & Performance =====
config.scrollback_lines = 10000
-- config.front_end = "OpenGL"
config.max_fps = 60
config.animation_fps = 60

-- ===== Terminal & Input =====
config.term = "wezterm"
config.audible_bell = "Disabled"

return config
