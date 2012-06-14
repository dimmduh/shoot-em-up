Turel = {}

function Turel:new(params)
    local turel = {}
	
	--create a shape
	turel = display.newImage("img/barrel-h.png", params.x, params.y)
	turel.xScale = 0.5
	turel.yScale = 0.5
	turel.xReference = -78
	
	turel.x = params.x
	turel.y = params.y
	
	turel.shootRate = 20; -- shoots per second	
	turel.shootSleep = 100;
	turel.shootSleepMax = fps / turel.shootRate; 
	
	--controller notify this
	function turel:controllerNotify(e)
		if (e.phase ~= 'ended') then
			self.rotation = -e.degree
		end
	end
	
	function turel:enterFrame(e)
		self:shoot();
	end

	function turel:shoot()
		if ( self.shootSleep > self.shootSleepMax ) then
			Bullet:new( { 
				x = self.x,
				y = self.y,
				angle = self.rotation
			});
			
			self.shootSleep = 0;
		end
		
		self.shootSleep = self.shootSleep + 1
	end
	
	Runtime:addEventListener('enterFrame', turel)
	
	return turel
end

return Turel