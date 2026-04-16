enemy = require("enemy")
button = require("button")
carrot = require("carrot")

math.randomseed(os.time())
world = love.physics.newWorld(0, 9.81 * 64, true)

-- main mavi charimiz
char = {
	height = 209,
	width = 225,
	speed = 130,
	body = love.physics.newBody(world, 100, 100, "dynamic"),
	shape = love.physics.newRectangleShape(160, 160),
	--x = 100,
	--y = 100,
}

char.fixture = love.physics.newFixture(char.body, char.shape)

ground = {
	body = love.physics.newBody(world, 0, 900, "static"),
	shape = love.physics.newRectangleShape(800, 50), 
}

ground.fixture = love.physics.newFixture(ground.body, ground.shape)

gate = {
	x = 1150,
	y = 1170,
	width = 300,
	height = 50,
}

local buttons = {
	menu_state = {},
	levels_state = {},
}

game = {	
	difficulty = 1,
	state = {
		menu = true,
		paused = false,
		running = false,
		ended = false
	}
}

carrots = {}
enemies = {}

function changeState(state)
	game.state["running"] = state == "running"
	game.state["menu"] = state == "menu"
	game.state["ended"] = state == "ended"
	game.state["paused"] = state == "paused"
end

function love.load()

	--spriteSheet = love.graphics.newImage("gfx/fail-anim.png")

	run_bg = love.graphics.newImage("gfx/bg-sur.png")
	menu_bg = love.graphics.newImage("gfx/rect5.png")

	char.sprite = love.graphics.newImage("gfx/char-bad.png")

	font = love.graphics.newFont(40)
	font2 = love.graphics.newFont(70)
	name_font = love.graphics.newFont("LoveDays-2v7Oe.ttf", 120)

-- buttoncuklari elave edeyin
	buttons.menu_state.play = button("PLAY", nil, nil, 150, 80)
	buttons.menu_state.settings = button("SETTINGS", nil, nil, 230, 80)
	buttons.menu_state.exit = button("EXIT", nil , nil, 150, 80)

-- bir dene enemi ve carrot elave edeyin
	table.insert(enemies, 1, enemy())
	table.insert(carrots, 1, carrot())
end

function love.update(dt)

	char.x = char.body:getX()
	char.y = char.body:getY()
	char.body:setFixedRotation(true)

	world:update(dt)

	mouse_x, mouse_y = love.mouse.getPosition()

-- play click edende
	if buttons.menu_state.play:hovering(mouse_x, mouse_y) and love.mouse.isDown(1) then
		changeState("running")
	end

-- char move
	vx, vy = char.body:getLinearVelocity()
	--[[if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
		char.y = char.y - char.speed*dt
	end
	if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
		char.y = char.y + char.speed*dt
	end ]]--
	if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
		vx = -char.speed
	end
	if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
		vx = char.speed
	else
		vx = 0
	end
	char.body:setLinearVelocity(vx, vy)

-- enemies de move 
	for i = 1, #enemies do
		if char.x > 160 or char.y > 160 then
				enemies[i]:move(char.x, char.y)
		end
	end

end

function love.draw()	

	love.graphics.setFont(font)

-- oyun run edende -> enemy ve char
	if game.state["running"] then
		love.graphics.printf("FPS: " .. love.timer.getFPS(), 10, 10, 100, "left")
		love.graphics.draw(run_bg, 0, 0)
		love.graphics.rectangle("fill", gate.x, gate.y, gate.width, gate.height)
		love.graphics.draw(char.sprite, char.x, char.y)

		for i = 1, #enemies do
			if enemies[i]:hit(char.x, char.y, char.width, char.height) then 
				changeState("ended")
			end
		end

		for i = 1, #enemies do
			enemies[i]:draw()
		end

		for i = 1, #carrots do
			carrots[i]:draw()
		end

		for i = #carrots, 1, -1 do
			if carrots[i]:eaten(char.x, char.y, char.width, char.height) then
				love.graphics.setFont(font)
				love.graphics.setColor(140/255, 40/255, 60/255)
				table.remove(carrots, i)
			end
		end
	end


-- menu olanda -> buttoncuklari cekirik
	if game.state["menu"] then
		love.graphics.setColor(250/255, 250/255, 250/255)
		love.graphics.draw(menu_bg, 0, 0)
		love.graphics.setColor(0, 0, 0)

		love.graphics.setColor(50/255, 140/255, 200/255)
		love.graphics.setFont(name_font)
		love.graphics.setColor(0,0,0)
		love.graphics.print("BAD GAME", 475, 155)


		love.graphics.setColor(69/255, 127/255, 193/255)
		love.graphics.print("BAD GAME", 470, 150)

		buttons.menu_state.play:draw(650, 400, 200, 400)
		buttons.menu_state.settings:draw(615, 550, 300, 400)
		buttons.menu_state.exit:draw(650, 700, 200, 400)
	end
end