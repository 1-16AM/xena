local Drawing = Drawing or nil

local Renderer = {
    Circles = {},
    Text = {},
    Lines = {},
    Squares = {}
}

function Renderer.new(type, properties)
    local drawing = Drawing.new(type)
    for prop, value in pairs(properties or {}) do
        drawing[prop] = value
    end
    return drawing
end

function Renderer:CreateCircle(properties)
    local circle = {
        Main = self.new("Circle", properties),
        Outline = nil,
        Properties = properties or {},
        
        SetVisible = function(self, state)
            self.Main.Visible = state
            if self.Outline then
                self.Outline.Visible = state
            end
        end,
        
        SetPosition = function(self, position)
            self.Main.Position = position
            if self.Outline then
                self.Outline.Position = position
            end
        end,
        
        AddOutline = function(self, properties)
            self.Outline = self.new("Circle", properties)
            return self
        end,
        
        Update = function(self, mainProps, outlineProps)
            for prop, value in pairs(mainProps or {}) do
                self.Main[prop] = value
            end
            
            if self.Outline and outlineProps then
                for prop, value in pairs(outlineProps) do
                    self.Outline[prop] = value
                end
            end
        end,
        
        Remove = function(self)
            self.Main:Remove()
            if self.Outline then
                self.Outline:Remove()
            end
            self = nil
        end
    }
    
    table.insert(self.Circles, circle)
    return circle
end

return Renderer
