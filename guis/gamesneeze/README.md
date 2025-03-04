# UI Library Documentation

## Table of Contents
1. [Getting Started](#getting-started)
2. [Window](#window)
3. [Pages](#pages)
4. [Sections](#sections)
5. [Elements](#elements)
6. [Utilities](#utilities)

## Getting Started

### Loading the Library
```lua
local library = loadstring(game:HttpGet("path/to/library.lua"))()
```

### Basic Usage
```lua
local window = library:New({
    name = "Window Title",
    size = Vector2.new(504, 604),
    accent = Color3.fromRGB(55, 175, 225)
})

local page = window:Page({
    name = "Page Name"
})

local section = page:Section({
    name = "Section Name"
})
```

## Window
The main container for your UI.

### Properties
- name (string) - Window title
- size (Vector2) - Window size
- accent (Color3) - Accent color
- callback (function) - Called when window state changes

### Methods
- window:Fade() - Toggle window visibility
- window:Initialize() - Initialize the window
- window:Watermark(info) - Add watermark
- window:KeybindsList(info) - Add keybinds list
- window:StatusList(info) - Add status list
- window:Unload() - Remove the UI

## Pages
Containers for sections, accessed via tabs.

### Properties
- name (string) - Page name
- size (number) - Page size

### Methods
- page:Section(info) - Create a new section
- page:MultiSection(info) - Create multiple sections
- page:PlayerList(info) - Create player list

## Sections
Containers for UI elements.

### Properties
- name (string) - Section name
- size (number) - Section size
- side ("left"/"right") - Section position

### Methods
All element creation methods below.

## Elements

### Label
```lua
section:Label({
    name = "Label Text",
    middle = false, -- Center text
    pointer = "label_pointer"
})
```

### Button
```lua
section:Button({
    name = "Button Name",
    callback = function() end,
    pointer = "button_pointer"
})
```

### Toggle
```lua
section:Toggle({
    name = "Toggle Name",
    def = false, -- Default state
    pointer = "toggle_pointer",
    callback = function(state) end
})
```

### Slider
```lua
section:Slider({
    name = "Slider Name",
    def = 50, -- Default value
    min = 0,
    max = 100,
    decimals = 1,
    suffix = "%", -- Value suffix
    pointer = "slider_pointer",
    callback = function(value) end
})
```

### Dropdown
```lua
section:Dropdown({
    name = "Dropdown Name",
    def = "Option 1",
    options = {"Option 1", "Option 2", "Option 3"},
    max = 8, -- Max visible items
    pointer = "dropdown_pointer",
    callback = function(option) end
})
```

### Multibox
```lua
section:Multibox({
    name = "Multibox Name",
    def = {"Option 1"},
    options = {"Option 1", "Option 2", "Option 3"},
    min = 0, -- Minimum selections
    pointer = "multibox_pointer",
    callback = function(options) end
})
```

### Colorpicker
```lua
section:Colorpicker({
    name = "Colorpicker Name",
    def = Color3.fromRGB(255, 0, 0),
    transparency = 0, -- Optional transparency
    pointer = "colorpicker_pointer",
    callback = function(color) end
})
```

### Keybind
```lua
section:Keybind({
    name = "Keybind Name",
    def = Enum.KeyCode.G,
    mode = "Toggle", -- "Toggle", "Hold", "Always"
    pointer = "keybind_pointer",
    callback = function(key) end
})
```

### Textbox
```lua
section:TextBox({
    name = "Textbox Name",
    def = "Default Text",
    placeholder = "Enter text...",
    max = 50, -- Character limit
    pointer = "textbox_pointer",
    callback = function(text) end
})
```

### List
```lua
section:List({
    options = {"Item 1", "Item 2", "Item 3"},
    max = 8, -- Max visible items
    current = 1, -- Default selected index
    pointer = "list_pointer",
    callback = function(item) end
})
```

## Utilities

### Pointers
Access elements using pointers:
```lua
library.pointers["pointer_name"]:Set(value)
library.pointers["pointer_name"]:Get()
```

### Themes
Available theme colors:
- accent
- lightcontrast
- darkcontrast
- outline
- inline
- textcolor
- textdark
- textborder
- cursoroutline

### Window Features
- Draggable
- Minimizable
- Customizable keybind
- Auto-saves configuration
- Smooth animations

### Additional Features
- Watermark support
- Keybinds list
- Status indicators
- Player list
- Multi-page support
- Responsive layout
- Custom cursor

### Event Connections
The library supports these events:
- began
- ended
- changed

These can be used to create custom behaviors and interactions with UI elements.
