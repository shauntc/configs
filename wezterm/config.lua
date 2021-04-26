local wezterm = require 'wezterm'
local font = wezterm.font_with_fallback({"CaskaydiaCove Nerd Font"});
return {
    font_dirs = {"../fonts"},
    color_scheme = "MaterialDark",
    font = font,
    automatically_reload_config = false,
    default_prog = {"powershell.exe"},
    font_size = 16,
    allow_square_glyphs_to_overflow_width = "WhenFollowedBySpace",
    window_close_confirmation="NeverPrompt",
    dont_warn_about_missing_fonts = true,
    tab_and_split_indices_are_zero_based = true,
    enable_scroll_bar = true,
    -- tmux like keybindings
    leader = { key="b", mods="CTRL", timeout_milliseconds=1000},
    keys = {
        {key='"', mods="LEADER|SHIFT", action=wezterm.action{SplitVertical={domain="CurrentPaneDomain"}}},
        {key='%', mods="LEADER|SHIFT", action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},
        {key='UpArrow', mods="LEADER", action=wezterm.action{ActivatePaneDirection="Up"}},
        {key='k', mods="LEADER", action=wezterm.action{ActivatePaneDirection="Up"}},
        {key='DownArrow', mods="LEADER", action=wezterm.action{ActivatePaneDirection="Down"}},
        {key='j', mods="LEADER", action=wezterm.action{ActivatePaneDirection="Down"}},
        {key='LeftArrow', mods="LEADER", action=wezterm.action{ActivatePaneDirection="Left"}},
        {key='h', mods="LEADER", action=wezterm.action{ActivatePaneDirection="Left"}},
        {key='RightArrow', mods="LEADER", action=wezterm.action{ActivatePaneDirection="Right"}},
        {key='l', mods="LEADER", action=wezterm.action{ActivatePaneDirection="Right"}},
        {key='c', mods="LEADER", action=wezterm.action{SpawnTab="CurrentPaneDomain"}},
        {key='&', mods="LEADER|SHIFT", action=wezterm.action{CloseCurrentTab={confirm=false}}},
        {key='o', mods="LEADER", action=wezterm.action{ActivateTabRelative=1}},
        {key='o', mods="LEADER|SUPER", action=wezterm.action{ActivateTabRelative=-1}},
        {key='f', mods="LEADER", action=wezterm.action{Search={CaseInSensitiveString=""}}},
        {key='F', mods="LEADER", action=wezterm.action{Search={CaseSensitiveString=""}}},
    },
    mouse_bindings = {
        {event={Up={streak=1, button="Left"}},mods="NONE",action=wezterm.action{CompleteSelection="PrimarySelection"}},
        {event={Up={streak=1, button="Left"}}, mods="CTRL", action="OpenLinkAtMouseCursor"}
    },
    window_padding = {
        left = 8,
        right = 8,
        top = 0,
        bottom = 0,
    },
    inactive_pane_hsb = {
        saturation = 1.0,
        brightness = 0.5,
    }
}
