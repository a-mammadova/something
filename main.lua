enemy = require("enemy")
button = require("button")
carrot = require("carrot")
math.randomseed(os.time())

char = {
	height = 209, width = 225,
	x = 100, y = 100,
	speed = 150,
}

gate = {
	x = 1150, y = 1170,
	width = 300, height = 50,
}

local buttons = {
	menu_state = {},
	levels = {},
	run_state = {},
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

carrots, enemies = {}, {}

function changeState(state)
	game.state["running"] = state == "running"
	game.state["menu"] = state == "menu"
	game.state["ended"] = state == "ended"
	game.state["paused"] = state == "paused"
end


function love.load()
	heart = 3
	run_bg = love.graphics.newImage("gfx/game-2.png")
	menu_bg = love.graphics.newImage("gfx/menu-2.png")
	char.sprite = love.graphics.newImage("gfx/blue-2.png")
	heart_pic = love.graphics.newImage("gfx/heart.png")

	font, font2 = love.graphics.newFont(40), love.graphics.newFont(70)

	buttons.menu_state.play = button("PLAY", nil, nil, 150, 80)
	buttons.menu_state.settings = button("SETTINGS", nil, nil, 230, 80)
	buttons.menu_state.exit = button("EXIT", nil , nil, 150, 80)
	buttons.run_state.pause = button("PAUSE", nil, nil, 170, 80)
	buttons.run_state.replay = button("REPLAY", nil, nil, 190, 80)

	table.insert(enemies, 1, enemy())
	table.insert(carrots, 1, carrot())
end

function love.update(dt)

	mouse_x, mouse_y = love.mouse.getPosition()

	function love.mousepressed(x, y, button)
	 if button == 1 then
        if game.state["menu"] then
            if buttons.menu_state.play:hovering(x, y) then
                changeState("running")
            end
        end

    	if game.state["running"] then
            if buttons.run_state.pause:hovering(x, y) then
                changeState("paused")
            end
        end

        if game.state["paused"] then
        	if buttons.run_state.replay: hovering(x, y) then
        		changeState("running")
        	end
        end
    end
end

	-- char move
	if game.state["running"] then
		if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
			char.y = char.y - char.speed*dt
		end
		if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
			char.y = char.y + char.speed*dt
		end
		if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
			char.x = char.x - char.speed*dt
		end
		if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
			char.x = char.x + char.speed*dt
		end
	end

	-- enemies de move 
	if game.state["running"] then
		for i = 1, #enemies do
			if char.x > 160 or char.y > 160 then
					enemies[i]:move(char.x, char.y)
			end
		end
	end

end

function love.draw()	

	love.graphics.setFont(font)

	-- oyun run edende -> enemy ve char
	if game.state["running"] then
		
		--love.graphics.printf("FPS: " .. love.timer.getFPS(), 10, 10, 100, "left")
		love.graphics.draw(run_bg, 0, 0)
		love.graphics.rectangle("fill", gate.x, gate.y, gate.width, gate.height)
		love.graphics.draw(char.sprite, char.x, char.y)

		buttons.run_state.pause:draw(1300, 30, 200, 400)
		love.graphics.setColor(1, 1, 1)

		for i = 1, heart do
			love.graphics.draw(heart_pic, 80*i, 15)
		end

		for i = 1, #enemies do
			if enemies[i]:hit(char.x, char.y, char.width, char.height) then 
				heart = heart - 1
				love.graphics.setFont(font2)
				love.graphics.print("LOST A HEART", 750, 600)
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

	if game.state["paused"] then
		buttons.run_state.replay:draw(645, 550, 300, 400)	
	end

	if game.state["menu"] then
		love.graphics.setColor(250/255, 250/255, 250/255)
		love.graphics.draw(menu_bg, 0, 0)
		love.graphics.setColor(0, 0, 0)

		buttons.menu_state.play:draw(650, 400, 200, 400)
		buttons.menu_state.settings:draw(615, 550, 300, 400)
		buttons.menu_state.exit:draw(650, 700, 200, 400)
	end
end