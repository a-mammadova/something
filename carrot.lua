function carrot() 
	return {
		sprite = love.graphics.newImage("gfx/carrot.png"),
		height = 100,
		width = 45,
		x = math.random(1, 18) * 80,
		y = math.random(1, 15) * 80,

		draw = function(self, t)
			love.graphics.draw(self.sprite, self.x, self.y + math.sin(time * 2) + 1)
			love.graphics.setColor(199/255, 148/255, 209/200)
		end,

		eaten = function(self, charx, chary, charw, charh)
			if self.x >= charx and self.x <= charx + charw then
				if self.y >= chary and self.y <= chary + charh then
					return true
				else
					return false
				end
			else
				return false
			end
		end,

	}
end
return carrot