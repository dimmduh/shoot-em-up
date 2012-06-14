Bullet = {}

function Bullet:new(params)
    local bullet = {}
	
	--create a shape
	bullet = display.newImage("img/bullet.png", params.x, params.y)	
	bullet.destroied = false
	
	bullet.x = params.x
	bullet.y = params.y
	bullet.rotation = params.angle;
	bullet.speed = 20;
	
	function bullet:enterFrame(e)
		if (self.destroied ) then
			self:destroy()
			return true;
		end
		
		--check object coordinates
		if ( self:isOut() ) then
			self.destroied = true;
		end
	
		--calculate offset
		self.dx = math.cos( math.rad( self.rotation) ) * self.speed;
		self.dy = math.sin( math.rad( self.rotation) ) * self.speed;
		
		--moving
		self.x = self.x + self.dx
		self.y = self.y + self.dy
		
		self:checkCollision()
	end
	
	
	function bullet:destroy()
		Runtime:removeEventListener("enterFrame", self)	
		self:removeSelf();
	end
	
	function bullet:isOut()
		return ( (self.x < -100) 
		or (self.x > _W + 100)
		or (self.y < -100)
		or (self.y > _H + 100) )
	end
	
	function bullet:checkCollision()
		if (#worms > 0) then
			for key, worm in pairs( worms ) do
				if (worm.x) then --if worm was deleted
					local distance = utils.getDistance( self.x, self.y, worm.x, worm.y )
					if ( distance < (24 * worm.xScale / 2 + self.width) ) then
						self.destroied = true;
						worm:kill();
					end
				end
			end
		end
	end
	
	Runtime:addEventListener('enterFrame', bullet)
	
	return bullet
end

return Bullet