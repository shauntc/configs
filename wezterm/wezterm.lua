-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.color_scheme = 'MaterialDark'
config.font_dirs = { "../fonts" }
config.font = wezterm.font('CaskaydiaCove Nerd Font')
config.font_size = 12.0
config.default_prog = {'nu.exe'}
config.default_cwd = "C:\\src\\"
config.inactive_pane_hsb = {
  saturation = 1.0,
  brightness = 0.5
}
config.window_close_confirmation = 'NeverPrompt'
config.allow_square_glyphs_to_overflow_width = "WhenFollowedBySpace"
config.window_frame = {
  font_size = 12
}

config.enable_scroll_bar = true
config.window_padding = {
  left = 8,
  right = 8,
  top = 0,
  bottom = 0
}

return config