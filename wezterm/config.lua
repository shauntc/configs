local wezterm = require 'wezterm'
return {
    font_dirs = {"../fonts"},
    color_scheme = "MaterialDark",
    font = wezterm.font("CaskaydiaCove Nerd Font"),
    default_prog = {"powershell.exe"},
    font_size = 16,
    allow_square_glyphs_to_overflow_width = "WhenFollowedBySpace",

    -- tmux like keybindings
    leader = { key="b", mods="CTRL", timeout_miliseconds=1000},
    keys = {
        {key='"', mods="LEADER|SHIFT", action=wezterm.action{SplitVertical={domain="CurrentPaneDomain"}}},
        {key='%', mods="LEADER|SHIFT", action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},
        {key='UpArrow', mods="LEADER", action=wezterm.action{ActivatePaneDirection="Up"}},
        {key='DownArrow', mods="LEADER", action=wezterm.action{ActivatePaneDirection="Down"}},
        {key='LeftArrow', mods="LEADER", action=wezterm.action{ActivatePaneDirection="Left"}},
        {key='RightArrow', mods="LEADER", action=wezterm.action{ActivatePaneDirection="Right"}},
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
    }
}