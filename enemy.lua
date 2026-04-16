
function enemy()
	return {
		level = 1,
		x = 30,
		y = 30,
		sprite = love.graphics.newImage("gfx/enemybad.png"),
		x = math.random(1, 18) * 80,
		y= math.random(1, 15)* 80,

		move = function(self, charx, chary)
			
			if charx - self.x > 0 then
				self.x = self.x + self.level/1.7
			elseif charx - self.x < 0 then
				self.x = self.x - self.level/1.7
			end

			if chary - self.y > 0 then
				self.y = self.y + self.level/1.7
			elseif chary - self.y < 0 then
				self.y = self.y - self.level/1.7
			end
		end,

		draw = function(self)
			love.graphics.draw(self.sprite, self.x, self.y)
			love.graphics.setColor(1, 1, 1)
		end,

		hit = function(self, charx, chary, charw, charh)
			if self.x >= charx and self.x <= charx + charw then
				if self.y >= chary and self.y <= chary + charh then
					return true
				else
					return false
				end
			end
		end,
	}
end

return enemy