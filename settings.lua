local wezterm = require 'wezterm'

return {

    -- Gaps
    window_padding = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
    },

    -- Tab Bar
    tab_bar_at_bottom = true,
    use_fancy_tab_bar = false,
    tab_max_width = 32,
    show_new_tab_button_in_tab_bar = false,

    colors = {
        tab_bar = {
            inactive_tab_edge = '#575757',
            background = '#282c34',
        },
    },

    -- Change default cursor
    default_cursor_style = 'BlinkingBar',
    cursor_blink_rate = 500,
    cursor_thickness = 2.5,

    -- Color scheme
    color_scheme = 'MaterialOcean',

    -- Font
    font_size = 15,
    font = wezterm.font('CodeNewRoman Nerd Font Mono'),

    -- Scroll bar
    enable_scroll_bar = false,
}
