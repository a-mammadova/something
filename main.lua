enemy = require("enemy")
button = require("button")
carrot = require("carrot")
math.randomseed(os.time())

char = {
	height = 209, width = 225,
	x = 100, y = 100,
	speed = 200,
}

gate = {
	x = 1150, y = 1170,
	width = 300, height = 50,
}

local buttons = {
	menu_state = {},
	levels = {},
	run_state = {},
	pause_state = {},
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

carrots, enemies, time = {}, {}, 0

function changeState(state)
	game.state["running"] = state == "running"
	game.state["menu"] = state == "menu"
	game.state["ended"] = state == "ended"
	game.state["paused"] = state == "paused"
end

score = 0

function resetGame()

	char.x, char.y, heart = 100, 100, 3
	carrots, enemies, time = {}, {}, 0

	score, started = 0, false

	table.insert(carrots, 1, carrot())
	table.insert(enemies, enemy())
end

function love.load()
	hit_timer = 0
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
	buttons.pause_state.continue = button("CONTINUE", nil, nil, 250, 80)
	buttons.pause_state.replay = button("REPLAY", nil, nil, 190, 80)

	table.insert(enemies, 1, enemy())
	table.insert(carrots, 1, carrot())
end

function love.update(dt)

	time = time + dt

	hit_timer = hit_timer - dt

	mouse_x, mouse_y = love.mouse.getPosition()

	currentSecond = math.floor(time)

	if started == true and currentSecond ~= lastSecond then
		lastSecond = currentSecond

    	if currentSecond % 1 == 0 then
       		score = score + 1
   		end
	end

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
        	if buttons.pause_state.continue:hovering(x, y) then
        		changeState("running")
        	end
        end

        if game.state["paused"] then
        	if buttons.pause_state.replay:hovering(x, y) then
        		resetGame()
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
					started = true
			end
		end
	end

	if score < 0 or heart == 0 then
		changeState("ended")
	end

end

function love.draw()	

	love.graphics.setFont(font)

	-- RUNNING
	if game.state["running"] then
		
		love.graphics.draw(run_bg, 0, 0)
		love.graphics.printf("FPS:" .. love.timer.getFPS(), 10, 1080, 200, "justify")

		--SCORE
		love.graphics.setColor(120/255, 34/255, 100/255)
		love.graphics.rectangle("fill", 600, 30, 300, 50)
		love.graphics.setColor(1, 1, 1)
		love.graphics.printf("SCORE: " ..score, 600, 30, 300, "center")

		--GATE
		love.graphics.setColor(0, 0, 0)
		love.graphics.rectangle("fill", gate.x - 10, gate.y - 10,
		 gate.width + 20, gate.height + 10)
		love.graphics.setColor(139/255, 69/255, 19/255)
		love.graphics.rectangle("fill", gate.x, gate.y, gate.width, gate.height)
		love.graphics.setColor(0, 0, 0)
		love.graphics.circle("line", gate.x + gate.width / 2, gate.y + gate.height / 3, 6)
		love.graphics.setColor(1, 1, 1)

		--HEART
		for i = 1, heart do
			love.graphics.draw(heart_pic, 80*i, 15)
		end
		buttons.run_state.pause:draw(1300, 30, 200, 400)
		love.graphics.setColor(1, 1, 1)

		offset_y = math.sin(time * 3) * 10 
		love.graphics.push()
		love.graphics.draw(char.sprite, char.x, char.y + offset_y)

		for i = 1, #carrots do
			carrots[i]:draw(time)
		end

		for i = #carrots, 1, -1 do
			if carrots[i]:eaten(char.x, char.y, char.width, char.height) then
				score = score + 10
				table.remove(carrots, i)
				table.insert(carrots, 1, carrot())
			end
		end

		love.graphics.pop()

		for i = 1, #enemies do
			if enemies[i]:hit(char.x, char.y, char.width, char.height) and hit_timer <= 0 then 
				heart = heart - 1
				love.graphics.setFont(font2)
				love.graphics.print("LOST A HEART", 750, 600)
				score = score - 20
				hit_timer = 1
			end
		end

		if hit_timer > 0 then
			love.graphics.setColor(1, 0, 0, 0.1)
			love.graphics.rectangle("fill", 0, 0, 1500, 1200)
		else
			love.graphics.setColor(1, 1, 1)
		end


		for i = 1, #enemies do
			enemies[i]:draw()
		end

	end

	if game.state["ended"] then
		love.graphics.setColor(1, 0, 0)
		love.graphics.setFont(font2)
		love.graphics.printf("GAME OVER !", 450, 500, 600, "center")
		love.graphics.setColor(1, 1, 1)
		--love.graphics.draw()
	end

	if game.state["paused"] then
		buttons.pause_state.continue:draw(635, 550, 300, 400)	
		buttons.pause_state.replay:draw(660, 430, 300, 400)
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