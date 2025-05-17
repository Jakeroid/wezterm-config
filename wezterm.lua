-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- 
-- This is where you actually apply your config choices
--

-- Make easily access to wezterm.mux
local w_mux = wezterm.mux

-- Load settings from settings.lua
-- Assuming settings.lua is in the same directory as wezterm.lua
local user_settings = require 'settings'
for k, v in pairs(user_settings) do
  config[k] = v
end

-- Load keybindings from keybindings.lua
-- Assuming keybindings.lua is in the same directory as wezterm.lua
config.keys = require 'keybindings'

-- Load Neovim integration (event handlers, leader key logic)
-- Assuming nvim_integration.lua is in the same directory
require 'nvim_integration'

-- Event Handlers and other logic:

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)

    -- Get the active pane's title and extract the last part of the path.
    local full_title = tab.active_pane.title or ""
    -- local basename = full_title:match("([^/]+)$") or full_title
    -- local title = basename

    -- Get the foreground process full name (e.g. /usr/bin/zsh)
    -- local process_full = tab.active_pane.foreground_process_name or ""

    -- Extract just the executable name; handles both / and \ as separators.
    -- local process_basename = process_full:match("([^/\\]+)$") or process_full

    -- Get the tab number (make it 1-indexed)
    local tab_number = tab.tab_index + 1

    -- Build the combined text.
    local text = tab_number .. ":" .. full_title

    -- If the combined text is too long, trim it.
    if #text > max_width - 3 then
        text = string.sub(text, 1, max_width - 3) .. "…"
    end

    -- if tab.is_active then
    --     return {
    --         { Background = { Color = "#282c34" } },
    --         { Foreground = { Color = "#000000" } },
    --         { Text = "" },
    --         { Background = { Color = "#000000" } },
    --         { Foreground = { Color = "#cccccc" } },
    --         { Text = text },
    --         { Background = { Color = "#282c34" } },
    --         { Foreground = { Color = "#000000" } },
    --         { Text = "" },
    --     }
    -- else
    --     return {
    --         { Background = { Color = "#282c34" } },
    --         { Foreground = { Color = "#1c1f24" } },
    --         { Text = "" },
    --         { Background = { Color = "#1c1f24" } },
    --         { Foreground = { Color = "#a0a0a0" } },
    --         { Text = text },
    --         { Background = { Color = "#282c34" } },
    --         { Foreground = { Color = "#1c1f24" } },
    --         { Text = "" },
    --     }
    -- end

    if tab.is_active then
        return {
            { Background = { Color = "#000000" } },
            { Foreground = { Color = "#282c34" } },
            { Text = "" },
            { Background = { Color = "#000000" } },
            { Foreground = { Color = "#cccccc" } },
            { Text = text },
            { Background = { Color = "#282c34" } },
            { Foreground = { Color = "#000000" } },
            { Text = "" },
        }
    else
        return {
            { Background = { Color = "#1c1f24" } },
            { Foreground = { Color = "#282c34" } },
            { Text = "" },
            { Background = { Color = "#1c1f24" } },
            { Foreground = { Color = "#a0a0a0" } },
            { Text = text },
            { Background = { Color = "#282c34" } },
            { Foreground = { Color = "#1c1f24" } },
            { Text = "" },
        }
    end
end)

-- Add Switching Workspaces --
wezterm.on('update-right-status', function(window, pane)
    window:set_right_status(window:active_workspace())
end)

-- -- Function to generate a random workspace name
-- local function random_workspace_name()
--     return "workspace_" .. math.random(1000, 9999)
-- end

-- -- Handle launcher selection
-- wezterm.on("launcher-select", function(window, pane, id, label)
--     if id == "new_named" then
--         -- Prompt for a named workspace
--         window:perform_action(
--             w_act.PromptInputLine {
--                 description = wezterm.format {
--                     { Attribute = { Intensity = 'Bold' } },
--                     { Foreground = { AnsiColor = 'Fuchsia' } },
--                     { Text = 'Enter name for new workspace' },
--                 },
--                 action = wezterm.action_callback(function(window, pane, line)
--                     if line and line ~= "" then
--                         window:perform_action(
--                             w_act.SwitchToWorkspace { name = line },
--                             pane
--                         )
--                     end
--                 end),
--             },
--             pane
--         )
--     elseif id == "new_random" then
--         -- Create a workspace with a random name
--         local random_name = random_workspace_name()
--         window:perform_action(
--             w_act.SwitchToWorkspace { name = random_name },
--             pane
--         )
--     elseif id == "switch" then
--         -- Show fuzzy workspace selector
--         window:perform_action(
--             w_act.ShowLauncherArgs { flags = "FUZZY|WORKSPACES" },
--             pane
--         )
--     end
-- end)

-- Helper function to check if a file exists
local function file_exists(name)
    local f = io.open(name, "r")
    if f then
        f:close()
        return true
    else
        return false
    end
end

-- Default leader key value (e.g., backslash)
local vim_leader_key = " "

-- Define the path to your custom leader key config file.
-- For example, if you have ~/.wezterm.d/vim_leader_key.lua:
local leader_config_file = os.getenv("HOME") .. "/.config/nvim/lua/config/leader.lua"

-- Check if the file exists
if file_exists(leader_config_file) then
    -- Use pcall with dofile to safely load the file.
    -- It is assumed that the file returns a table with a key `vim_leader_key`
    local ok, config = pcall(dofile, leader_config_file)
    if ok and config and config.vim_leader_key then
        vim_leader_key = config.vim_leader_key
    end
end

-- Now use vim_leader_key in your event handlers
wezterm.on("copy_or_send_leader_y", function(window, pane)
    local process_name = pane:get_foreground_process_name() or ""
    if process_name:match("vim") or process_name:match("nvim") then
        window:perform_action(wezterm.action.SendKey({ key = vim_leader_key }), pane)
        window:perform_action(wezterm.action.SendKey({ key = "y" }), pane)
    else
        window:perform_action(wezterm.action.CopyTo("Clipboard"), pane)
    end
end)

wezterm.on("paste_or_send_leader_p", function(window, pane)
    local process_name = pane:get_foreground_process_name() or ""
    if process_name:match("vim") or process_name:match("nvim") then
        window:perform_action(wezterm.action.SendKey({ key = vim_leader_key }), pane)
        window:perform_action(wezterm.action.SendKey({ key = "p" }), pane)
    else
        window:perform_action(wezterm.action.PasteFrom("Clipboard"), pane)
    end
end)

-- -- Make CMD+C and CMD+V work in Vim by using Vim bindings
-- wezterm.on("copy_or_send_leader_y", function(window, pane)
--     local process_name = pane:get_foreground_process_name() or ""
--     if process_name:match("vim") or process_name:match("nvim") then
--         window:perform_action(wezterm.action.SendKey({ key = "\\" }), pane) -- Leader key
--         window:perform_action(wezterm.action.SendKey({ key = "y" }), pane) -- 'y' key
--     else
--         window:perform_action(wezterm.action.CopyTo("Clipboard"), pane)
--     end
-- end)
-- wezterm.on("paste_or_send_leader_p", function(window, pane)
--     local process_name = pane:get_foreground_process_name() or ""
--     if process_name:match("vim") or process_name:match("nvim") then
--         window:perform_action(wezterm.action.SendKey({ key = "\\" }), pane) -- Leader key
--         window:perform_action(wezterm.action.SendKey({ key = "p" }), pane) -- 'p' key
--     else
--         window:perform_action(wezterm.action.PasteFrom("Clipboard"), pane)
--     end
-- end)

-- Keys
config.keys = {

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
                -- line will be `nil` if they hit escape without entering anything
                -- An empty string if they just hit enter
                -- Or the actual line of text they wrote
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

-- Maximize window on startup
wezterm.on('gui-startup', function(cmd)
    local tab, pane, window = w_mux.spawn_window(cmd or {})
    local gui_win = window:gui_window()
    window:gui_window():toggle_fullscreen()
end)

-- -- Local server for persistent sessions (moved to settings.lua)
-- config.unix_domains = {
--     {
--         name = "jakeroid",
--     },
-- }
-- config.default_gui_startup_args = { "connect", "jakeroid" }

return config
