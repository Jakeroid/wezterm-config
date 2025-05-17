local wezterm = require 'wezterm'

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

-- Default leader key value
local vim_leader_key = " "

-- Define the path to your custom leader key config file.
local leader_config_file = os.getenv("HOME") .. "/.config/nvim/lua/config/leader.lua"

-- Check if the file exists and load the leader key
if file_exists(leader_config_file) then
    local ok, leader_conf = pcall(dofile, leader_config_file)
    if ok and leader_conf and leader_conf.vim_leader_key then
        vim_leader_key = leader_conf.vim_leader_key
    end
end

-- Event handler for copy or sending leader + y to Neovim
wezterm.on("copy_or_send_leader_y", function(window, pane)
    local process_name = pane:get_foreground_process_name() or ""
    if process_name:match("vim") or process_name:match("nvim") then
        window:perform_action(wezterm.action.SendKey({ key = vim_leader_key }), pane)
        window:perform_action(wezterm.action.SendKey({ key = "y" }), pane)
    else
        window:perform_action(wezterm.action.CopyTo("Clipboard"), pane)
    end
end)

-- Event handler for paste or sending leader + p to Neovim
wezterm.on("paste_or_send_leader_p", function(window, pane)
    local process_name = pane:get_foreground_process_name() or ""
    if process_name:match("vim") or process_name:match("nvim") then
        window:perform_action(wezterm.action.SendKey({ key = vim_leader_key }), pane)
        window:perform_action(wezterm.action.SendKey({ key = "p" }), pane)
    else
        window:perform_action(wezterm.action.PasteFrom("Clipboard"), pane)
    end
end)

-- This file primarily sets up event handlers, so it doesn't need to return a table.
