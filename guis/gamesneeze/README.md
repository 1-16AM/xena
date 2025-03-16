# Complete UI Library Documentation

## Table of Contents
1. [Getting Started](#getting-started)
2. [Window Creation](#window-creation)
3. [Pages & Sections](#pages--sections)
4. [UI Elements](#ui-elements)
5. [Advanced Features](#advanced-features)
6. [Themes & Customization](#themes--customization)
7. [Examples](#examples)

## Getting Started

### Installation
```lua
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/1-16AM/xena/refs/heads/main/guis/gamesneeze/ui.lua"))()
```

### Basic Structure
```lua
-- Create window
local window = library:New({
    name = "Example Window",
    size = Vector2.new(504, 604),
    accent = Color3.fromRGB(55, 175, 225)
})

-- Create page
local page = window:Page({
    name = "Main Page"
})

-- Create section
local section = page:Section({
    name = "Settings"
})

-- Initialize the UI
window:Initialize()
```

## Window Creation

### Standard Window
```lua
local window = library:New({
    name = "Window Title",
    size = Vector2.new(504, 604),
    accent = Color3.fromRGB(55, 175, 225),
    callback = function(currentPage) 
        print("Page changed to:", currentPage.name)
    end
})
```

### Loader Window
```lua
local loader = library:Loader({
    name = "Loading...",
    size = Vector2.new(300, 200),
    accent = Color3.fromRGB(55, 175, 225),
    callback = function() 
        print("Loader complete")
    end,
    pages = 3 -- Number of pages to create
})
```

### Window Methods
```lua
-- Toggle visibility
window:Fade()

-- Add watermark
window:Watermark({
    name = "Username | FPS: %fps% | Ping: %ping%"
})

-- Add keybinds list
window:KeybindsList({
    title = "Active Keybinds"
})

-- Add status list
window:StatusList({
    title = "Status"
})

-- Unload UI
window:Unload()
```

## Pages & Sections

### Page Creation
```lua
local page = window:Page({
    name = "Page Name",
    size = 100 -- Optional custom size
})
```

### Section Types

#### Standard Section
```lua
local section = page:Section({
    name = "Section Name",
    size = 200,
    side = "left" -- or "right"
})
```

#### Multi Section
```lua
local section1, section2 = page:MultiSection({
    sections = {"Section 1", "Section 2"},
    size = 200,
    side = "left",
    callback = function(sectionName) end
})
```

#### Player List Section
```lua
local playerList = page:PlayerList({
    size = 200,
    callback = function(player, selected) end
})
```

## UI Elements

### Label
```lua
section:Label({
    name = "Information Text",
    middle = true, -- Center alignment
    pointer = "info_label"
})
```

### Button
```lua
section:Button({
    name = "Click Me",
    callback = function()
        print("Button clicked!")
    end,
    pointer = "main_button"
})

-- Button holder (multiple buttons)
section:ButtonHolder({
    buttons = {
        {name = "Button 1", callback = function() end},
        {name = "Button 2", callback = function() end}
    }
})
```

### Toggle
```lua
local toggle = section:Toggle({
    name = "Toggle Feature",
    def = false,
    pointer = "feature_toggle",
    callback = function(state)
        print("Toggle state:", state)
    end
})

-- Toggle with colorpicker
local colorpicker = toggle:Colorpicker({
    name = "Toggle Color",
    def = Color3.fromRGB(255, 0, 0),
    transparency = 0,
    pointer = "toggle_color",
    callback = function(color, alpha)
        print("Color selected:", color, "Alpha:", alpha)
    end
})

-- Toggle with keybind
local keybind = toggle:Keybind({
    name = "Toggle Bind",
    def = Enum.KeyCode.R,
    mode = "Toggle", -- "Toggle", "Hold", "Always"
    pointer = "toggle_key",
    callback = function(key)
        print("Key pressed:", key)
    end
})
```

### Slider
```lua
section:Slider({
    name = "Adjustment",
    def = 50,
    min = 0,
    max = 100,
    decimals = 1,
    suffix = "%",
    pointer = "adjustment_value",
    callback = function(value)
        print("Slider value:", value)
    end
})
```

### Dropdown
```lua
section:Dropdown({
    name = "Selection",
    def = "Option 1",
    options = {"Option 1", "Option 2", "Option 3"},
    max = 8,
    pointer = "dropdown_selection",
    callback = function(option)
        print("Selected:", option)
    end
})
```

### Multibox
```lua
section:Multibox({
    name = "Multiple Select",
    def = {"Option 1"},
    options = {"Option 1", "Option 2", "Option 3"},
    min = 0,
    pointer = "multi_selection",
    callback = function(selections)
        for _, selection in pairs(selections) do
            print("Selected:", selection)
        end
    end
})
```

### Colorpicker
```lua
section:Colorpicker({
    name = "Color Selection",
    def = Color3.fromRGB(255, 0, 0),
    transparency = 0,
    pointer = "color_picker",
    callback = function(color, alpha)
        print("Color:", color, "Alpha:", alpha)
    end
})

-- Double colorpicker
local colorpicker = section:Colorpicker(...)
colorpicker:Colorpicker({
    name = "Secondary Color",
    def = Color3.fromRGB(0, 255, 0),
    transparency = 0,
    pointer = "secondary_color",
    callback = function(color, alpha)
        print("Secondary color:", color, "Alpha:", alpha)
    end
})
```

### Keybind
```lua
section:Keybind({
    name = "Action Key",
    def = Enum.KeyCode.E,
    mode = "Toggle",
    pointer = "action_key",
    callback = function(key, active)
        print("Key:", key, "Active:", active)
    end
})
```

### Textbox
```lua
section:TextBox({
    name = "Input",
    def = "Default",
    placeholder = "Enter text...",
    max = 50,
    pointer = "text_input",
    callback = function(text)
        print("Input:", text)
    end
})
```

### List
```lua
section:List({
    options = {"Item 1", "Item 2", "Item 3"},
    max = 8,
    current = 1,
    pointer = "item_list",
    callback = function(item)
        print("Selected item:", item)
    end
})
```

## Advanced Features

### Pointers Usage
```lua
-- Set value
library.pointers["pointer_name"]:Set(newValue)

-- Get value
local value = library.pointers["pointer_name"]:Get()

-- Examples for different elements
library.pointers["toggle_pointer"]:Set(true)
library.pointers["slider_pointer"]:Set(75)
library.pointers["dropdown_pointer"]:Set("Option 2")
library.pointers["colorpicker_pointer"]:Set(Color3.fromRGB(255, 0, 0), 0)
library.pointers["keybind_pointer"]:Set(Enum.KeyCode.R)
```

### Configuration
```lua
-- Save configuration
local config = window:GetConfig()

-- Load configuration
window:LoadConfig(config)
```

### Custom Cursor
```lua
local cursor = window:Cursor({
    thickness = 1.5,
    color = Color3.fromRGB(255, 255, 255)
})
```

## Themes & Customization

### Available Theme Colors
```lua
local theme = {
    accent = Color3.fromRGB(55, 175, 225),
    lightcontrast = Color3.fromRGB(30, 30, 30),
    darkcontrast = Color3.fromRGB(20, 20, 20),
    outline = Color3.fromRGB(0, 0, 0),
    inline = Color3.fromRGB(50, 50, 50),
    textcolor = Color3.fromRGB(255, 255, 255),
    textdark = Color3.fromRGB(175, 175, 175),
    textborder = Color3.fromRGB(0, 0, 0),
    cursoroutline = Color3.fromRGB(10, 10, 10)
}
```

## Examples

### Complete UI Example
```lua
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/1-16AM/xena/refs/heads/main/guis/gamesneeze/ui.lua"))()

-- Create window
local window = library:New({
    name = "Example UI",
    size = Vector2.new(504, 604),
    accent = Color3.fromRGB(55, 175, 225)
})

-- Add watermark
window:Watermark({
    name = "Example UI | FPS: %fps% | Ping: %ping%"
})

-- Create pages
local mainPage = window:Page({
    name = "Main"
})

local settingsPage = window:Page({
    name = "Settings"
})

-- Create sections
local mainSection = mainPage:Section({
    name = "Features",
    side = "left"
})

local settingsSection = settingsPage:Section({
    name = "Configuration",
    side = "right"
})

-- Add elements
mainSection:Toggle({
    name = "Example Toggle",
    def = false,
    pointer = "main_toggle",
    callback = function(state)
        print("Toggle:", state)
    end
})

settingsSection:Slider({
    name = "Example Slider",
    def = 50,
    min = 0,
    max = 100,
    pointer = "main_slider",
    callback = function(value)
        print("Value:", value)
    end
})

-- Initialize
window:Initialize()
```

This documentation should provide a comprehensive overview of all available features and their usage. Each element and feature is documented with practical examples and explanations of all available options.
