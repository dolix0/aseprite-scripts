-----------------------------
-- By dolix
-- Creates a particle effect on a new layer.
-----------------------------

local sprite = app.activeSprite

-- quit and alert if there is no sprite 
if not sprite then 
    return app.alert("No sprite opened.")
end

-- get randomized position with given values
local function getRandomizedPosition(xOffset, yOffset)
	xOffset = xOffset or 0
	yOffset = yOffset or 0

	return {math.random(0 + xOffset, sprite.width - xOffset), 
			math.random(0 + yOffset, sprite.height- yOffset)}
end

-- NOTE: particles can currently be spawn on top of each other
local function createParticles(data)
	if not data.particle_file or data.particle_file == "" then
		return app.alert("No particle file was chosen or file is broken.")
	end

	if not data.particle_count or data.particle_count <= 0 then
		return app.alert("Invalid particle count.")
	end

	local particleImage = Image{fromFile=data.particle_file}

	-- check again if for some reason particleImage could not be created or is invalide due to an error of the particle file
	-- no need for an app alert since aseprite will tell the user automatically
	if not particleImage then
		return
	end

	local outputImage = Image(sprite.width, sprite.height)

	-- create new layer for particle effect
	local newLayer = sprite:newLayer()
	newLayer.name = "particle_layer"

	-- consider particle width and height for randomizing the position 
	-- and not allowing it to be drawn out of bounds of the sprite
	for i = 1, data.particle_count, 1 do
		outputImage:drawImage(particleImage, 
		getRandomizedPosition(particleImage.width, particleImage.height)) 
	end

	-- create new cel and center it correctly
	local cel = sprite:newCel(newLayer, 1, outputImage) 
	local center = Point(sprite.width/2 - cel.bounds.width/2,
						 sprite.height/2 - cel.bounds.height/2)
			 
	cel.position = center
end

local dialog = Dialog("Particle Effect")
dialog 
	:file{id="particle_file", label="Choose particle file", open=true, filetypes={"aseprite", "png", "jpeg", "jpg"}}
	:number{id="particle_count", label="Particle count", text="10"}
	:button{text="Start particle effect", onclick=function() createParticles(dialog.data) end}
	:show{wait=false}