# GameSneezeUI Documentation - docs made by claude

A lightweight and feature-rich UI library for Roblox exploiting.

## Table of Contents
- [Getting Started](#getting-started)
- [Window](#window)
- [Pages](#pages)
- [Sections](#sections)
- [Elements](#elements)
  - [Label](#label)
  - [Toggle](#toggle)
  - [Slider](#slider)
  - [Button](#button)
  - [TextBox](#textbox)
  - [Dropdown](#dropdown)
  - [MultiDropdown](#multidropdown)
  - [Keybind](#keybind)
  - [Colorpicker](#colorpicker)
  - [List](#list)

## Getting Started

```lua
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/1-16AM/xena/refs/heads/main/guis/gamesneeze/ui.lua"))()

-- Initialize theme
local theme = {
    accent = Color3.fromRGB(50, 100, 255),
    lightcontrast = Color3.fromRGB(30, 30, 30),
    darkcontrast = Color3.fromRGB(20, 20, 20),
    outline = Color3.fromRGB(0, 0, 0),
    inline = Color3.fromRGB(50, 50, 50),
    textcolor = Color3.fromRGB(255, 255, 255),
    textdark = Color3.fromRGB(175, 175, 175),
    textborder = Color3.fromRGB(0, 0, 0),
    font = Drawing.Fonts.Plex,
    textsize = 13
}
```

## Window

Create a new window:

```lua
local window = library:New({
    name = "GameSneezeUI",
    size = Vector2.new(600, 400),
    theme = theme
})
```

## Pages

Add pages to your window:

```lua 
local mainPage = window:Page({
    name = "Main",
    size = 100
})
```

## Sections

Create sections within pages:

```lua
local mainSection = mainPage:Section({
    name = "Main Section",
    side = "left"
})
```

## Elements

### Label

```lua
mainSection:Label({
    name = "This is a label"
})
```

### Toggle

```lua
local myToggle = mainSection:Toggle({
    name = "Toggle Example",
    def = false,
    pointer = "myToggle",
    callback = function(state)
        print("Toggle state:", state)
    end
})

-- Add colorpicker to toggle
myToggle:Colorpicker({
    name = "Toggle Color",
    def = Color3.fromRGB(255, 0, 0),
    transparency = 0,
    pointer = "toggleColor",
    callback = function(color, transparency)
        print("Color selected:", color, transparency)
    end
})

-- Add keybind to toggle
myToggle:Keybind({
    name = "Toggle Bind",
    def = Enum.KeyCode.E,
    mode = "Toggle", -- "Toggle", "Hold", "Always"
    pointer = "toggleBind",
    callback = function(key)
        print("Key pressed:", key)
    end
})
```

### Slider

```lua
mainSection:Slider({
    name = "Slider Example",
    min = 0,
    max = 100,
    def = 50,
    decimals = 1,
    pointer = "mySlider",
    callback = function(value)
        print("Slider value:", value)
    end
})
```

### Button

```lua
mainSection:Button({
    name = "Click Me!",
    pointer = "myButton",
    callback = function()
        print("Button clicked!")
    end
})
```

### TextBox

```lua
mainSection:TextBox({
    name = "Enter Text",
    def = "Default text",
    placeholder = "Type here...",
    pointer = "myTextbox",
    callback = function(text)
        print("Text entered:", text)
    end
})
```

### Dropdown

```lua
mainSection:Dropdown({
    name = "Select Option",
    def = "Option 1",
    options = {"Option 1", "Option 2", "Option 3"},
    pointer = "myDropdown",
    callback = function(option)
        print("Selected:", option)
    end
})
```

### MultiDropdown

```lua
mainSection:Multibox({
    name = "Multi Select",
    def = {"Option 1"},
    options = {"Option 1", "Option 2", "Option 3"},
    pointer = "myMultibox",
    callback = function(options)
        print("Selected options:", table.concat(options, ", "))
    end
})
```

### Keybind

```lua
mainSection:Keybind({
    name = "Press Key",
    def = Enum.KeyCode.RightShift,
    pointer = "myKeybind",
    mode = "Toggle",
    callback = function(key)
        print("Keybind pressed:", key)
    end
})
```

### Colorpicker

```lua
mainSection:Colorpicker({
    name = "Pick Color",
    def = Color3.fromRGB(255, 0, 0),
    transparency = 0,
    pointer = "myColorpicker",
    callback = function(color, transparency)
        print("Color picked:", color, transparency)
    end
})
```

### List

```lua
mainSection:List({
    name = "List Example",
    max = 8,
    options = {"Item 1", "Item 2", "Item 3", "Item 4", "Item 5"},
    def = 1,
    pointer = "myList",
    callback = function(selected)
        print("Selected item:", selected)
    end
})
```

## Accessing Values

You can access element values using pointers:

```lua
-- Get values
local toggleState = pointers.featureEnabled:Get()
local sliderValue = pointers.speedValue:Get()

-- Set values
pointers.featureEnabled:Set(true)
pointers.speedValue:Set(75)
```
