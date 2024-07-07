-----------------------------
-- By dolix
-- Selection will be cut from the current layer and split into its own new layer.
-----------------------------

local sprite = app.activeSprite

-- quit and alert if there is no sprite 
if not sprite then 
    return app.alert("No sprite opened.")
end

-- get selection of sprite
local selection = sprite.selection

-- quit and alert if nothing is selected
if selection.isEmpty then 
    return app.alert("Nothing has been selected.")
end

-- copy and paste selection
app.command.Cut()
app.command.NewLayer{ fromClipboard=true }

selection:deselect()