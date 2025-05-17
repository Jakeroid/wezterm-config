local wezterm = require 'wezterm'
local utils = require 'utils' -- Added to use utils.file_exists

-- Base configuration
local config = {

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

-- Helper function to check if a table is a list (array-like)
local function is_list(t)
    if type(t) ~= "table" or getmetatable(t) ~= nil then
        return false
    end
    local i = 0
    for _ in pairs(t) do
        i = i + 1
        if t[i] == nil then return false end -- Not a sequence 1..n
    end
    return true -- True if all keys are 1..n or if empty
end

-- Function to deeply merge two configuration tables
-- It merges 'override' into 'base'.
-- Map-like tables are merged recursively. List-like tables (arrays) are replaced.
local function merge_configs(base, override)
    local new_config = {}
    for k, v in pairs(base) do
        new_config[k] = v
    end

    for key, val_override in pairs(override) do
        local val_base = base[key]
        if type(val_base) == "table" and type(val_override) == "table" and
           getmetatable(val_base) == nil and getmetatable(val_override) == nil and
           not is_list(val_base) and not is_list(val_override) then
            -- Deep merge for map-like tables
            new_config[key] = merge_configs(val_base, val_override)
        else
            -- Replace for lists, non-tables, or objects with metatables
            new_config[key] = val_override
        end
    end
    return new_config
end

-- Define the path to your local override file
local local_settings_path = wezterm.config_dir .. "/local_settings.lua"

-- Check if the local override file exists and load it
if utils.file_exists(local_settings_path) then
    -- Use pcall to safely load and execute the local settings file
    local ok, local_overrides_or_error = pcall(dofile, local_settings_path)

    if ok then
        if type(local_overrides_or_error) == "table" then
            config = merge_configs(config, local_overrides_or_error)
            wezterm.log_info("Successfully loaded and merged local overrides from: " .. local_settings_path)
        else
            wezterm.log_error("local_settings.lua (" .. local_settings_path .. ") did not return a table.")
        end
    else
        -- local_overrides_or_error contains the error message here
        wezterm.log_error("Error loading/executing local_settings.lua: " .. tostring(local_overrides_or_error))
    end
else
    wezterm.log_info("No local_settings.lua found at: " .. local_settings_path .. ". Using default settings.")
end

return config
