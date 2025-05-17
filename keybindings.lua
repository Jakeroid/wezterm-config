local wezterm = require 'wezterm'
local w_act = wezterm.action -- Alias for wezterm.action

return {

    -- Make CMD+C and CMD+V work in Vim by using Vim bindings
    {
        key = "c",
        mods = "CMD",
        action = wezterm.action.EmitEvent("copy_or_send_leader_y"),
    },
    {
        key = "v",
        mods = "CMD",
        action = wezterm.action.EmitEvent("paste_or_send_leader_p"),
    },

    -- Remap CMD + w for closing pane instead of closing tab
    {
        key = 'w',
        mods = 'CMD',
        action = w_act.CloseCurrentPane { confirm = true },
    },

    -- Prompt for a name to use for a new workspace and switch to it.
    {
        key = '0',
        mods = 'ALT',
        action = w_act.PromptInputLine {
            description = wezterm.format {
                { Attribute = { Intensity = 'Bold' } },
                { Foreground = { AnsiColor = 'Fuchsia' } },
                { Text = 'Enter name for new workspace' },
            },
            action = wezterm.action_callback(function(window, pane, line)
                if line then
                    window:perform_action(
                        w_act.SwitchToWorkspace {
                            name = line,
                        },
                        pane
                    )
                end
            end),
        },
    },

    -- Workspaces manager.
    {
        key = '9',
        mods = 'ALT',
        action = w_act.ShowLauncherArgs {
            flags = 'FUZZY|WORKSPACES',
        },
    },
}
