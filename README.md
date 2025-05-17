# wezterm-config
My personal wezterm config.

## Installation

1.  **Clone the Repository:**
    Clone this repository into your WezTerm configuration directory. The typical location for WezTerm configuration is `~/.config/wezterm/` on Linux and macOS.

    ```bash
    # Replace <repository_url> with the actual URL of this repository
    git clone <repository_url> ~/.config/wezterm
    ```
    If you have already cloned the repository elsewhere, you can copy or symlink the configuration files (`wezterm.lua`, `settings.lua`, `nvim_integration.lua`, etc.) into `~/.config/wezterm/`.

2.  **Install Required Fonts:**
    This configuration uses "CodeNewRoman Nerd Font Mono" by default (as specified in `settings.lua`). Ensure you have this font installed on your system. If you prefer a different font, you can change it in `settings.lua` or, preferably, override it using `local_settings.lua` (see below).

3.  **Restart WezTerm:**
    After setting up the configuration, restart WezTerm for the changes to take effect.

## Local Settings (`local_settings.lua`)

To make personal customizations (like changing the font size, color scheme, or other specific settings) without modifying the core configuration files directly, you can use a `local_settings.lua` file. This approach is recommended because:
-   Your personal tweaks won't be overwritten when you pull updates from this repository.
-   The `local_settings.lua` file is ignored by Git (as specified in `.gitignore`).

**How to Use Local Settings:**

1.  **Create the File:**
    In your WezTerm configuration directory (e.g., `~/.config/wezterm/`), create a new file named `local_settings.lua`.

2.  **Add Your Overrides:**
    The `local_settings.lua` file should return a Lua table containing the settings you wish to override. The structure of this table should mirror the structure in `settings.lua`.

    Here's an example of what your `~/.config/wezterm/local_settings.lua` might look like:

    ```lua
    -- ~/.config/wezterm/local_settings.lua
    -- This file is for your personal overrides and is not tracked by Git.
    return {
        font_size = 18,          -- Overrides the font_size from settings.lua
        color_scheme = 'Noctis Lux', -- Overrides the color_scheme from settings.lua

        -- You can override any setting present in the main config.
        -- For example, to change window padding:
        -- window_padding = {
        --     left = 10,
        --     right = 10,
        --     top = 10,
        --     bottom = 10,
        -- },

        -- To use a different font:
        -- font = wezterm.font('JetBrains Mono Nerd Font'),
    }
    ```

3.  **How It Works:**
    The main `settings.lua` is configured to automatically detect and load `~/.config/wezterm/local_settings.lua` if it exists. The settings defined in your `local_settings.lua` will be deeply merged into the default configuration, with your local settings taking precedence.
