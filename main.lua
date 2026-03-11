function love.load()
	print("Game started")
	local icon = love.image.newImageData("gfx/mirta-logo.png")
	love.window.setIcon(icon)
	love.graphics.setBackgroundColor(12/255, 75/255, 105/255)

	wim = {
		x = 10, 
		y = 10,
		spirite = love.graphics.newImage("gfx/nese.png")
	}

	SPIRITE_WIDTH, SPIRITE_HEIGHT = 500, 128
	QUAD_WIDTH = 80
	QUAD_HEIGHT = SPIRITE_HEIGHT

	quads = {}

	for i = 1, 4 do
		quads[i] = love.graphics.newQuad((i-1) * QUAD_WIDTH, 0, QUAD_WIDTH, QUAD_HEIGHT, SPIRITE_WIDTH, SPIRITE_HEIGHT)
	end
end

function love.update(dt)
	

end

function love.draw()

	love.graphics.scale(3)
	for i = 1, 4 do
		love.graphics.draw(wim.spirite, quads[i], wim.x*10*i, wim.y)
	end

end