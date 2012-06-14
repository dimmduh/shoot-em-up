Controller = {}

function Controller:new(params)
    local controller = {}
	
	--create a shape
	controller = display.newCircle(params.x, params.y, params.radius)
	controller.radius = params.radius
	
	--it's difference between center point
	controller.dx = 0
	controller.dy = 0
	
	--set bg color and transparent
	controller:setFillColor(102, 51, 204, 100)
	
	--attached object, which under control this controller
	controller.attached = nil
	
	--analog mode
	controller.analogMode = true
	
	
	function controller:touch(e)
		
		--calculate difference
		local dx = (e.x - self.x) / self.radius, 1
		local dy = (e.y - self.y) / self.radius, 1
		
		--возможно здесь ошибка!! если палец запределами контроллера
		dx = utils.sign(dx) * math.min( math.abs(dx), 1)
		dy = utils.sign(dy) * math.min( math.abs(dy), 1)
		
		if (e.phase == 'began') then
			--if your finger is out area controller
			display.getCurrentStage():setFocus(e.target, e.id )
		elseif (e.phase == 'moved') then
		
		elseif (e.phase == 'ended') then
			display.getCurrentStage():setFocus(e.target, nil )
			
			--reset
			dx = 0
			dy = 0
		end

		local degree = utils.getAngle( self.x, self.y,  e.x, e.y );
		
		--analog mode
		if ( self.analogMode == false) then		
			dx, dy, degree = self:translateToDigital(dx, dy, degree)
		end
		
		self.degree = degree
		self.dx = dx
		self.dy = dy
		--p('!touch phase = ' .. e.phase  .. ' dx = ' .. dx .. '   dy = ' .. dy .. ' degree=' .. self.degree)
		
		self:notify(e.phase)
		
	end

	--преобразование в 8 направлений (0, 45, 90, 135, 180, 225, 270, 315)
	function controller:translateToDigital(dx, dy, degree)
		--dx
		if (
			( degree >= 0 and degree <= 60 ) or 
			( degree >= 120 and degree <= 240 ) or 
			( degree >= 300 and degree <= 360 )
		) then
			dx = utils.sign(dx)
		else
			dx = 0
		end
		
		--dy
		if (
			( degree >= 30 and degree <= 150 ) or 
			( degree >= 210 and degree <= 330 )
		) then		
			dy = utils.sign(dy)
		else
			dy = 0
		end
		
		--degree
		if ( dx == 1 ) then
			if ( dy == 1 ) then
				degree = 305
			elseif ( dy == 0 ) then
				degree = 0
			elseif ( dy == -1 ) then
				degree = 45
			end
		elseif ( dx == 0 ) then
			if ( dy == 1 ) then
				degree = 270
			elseif ( dy == 0 ) then
				degree = 0
			elseif ( dy == -1 ) then
				degree = 90
			end			
		elseif ( dx == -1 ) then
			if ( dy == 1 ) then
				degree = 215
			elseif ( dy == 0 ) then
				degree = 180
			elseif ( dy == -1 ) then
				degree = 135
			end
		end
		
		return dx, dy, degree
	end

	--attach object, which will notify
	function controller:attach(object)
		self.attached = object
	end

	--notify attached object
	function controller:notify(phase)
		if (self.attached) then
			self.attached:controllerNotify({phase = phase, target = self, dx = self.dx, dy = self.dy, degree = self.degree})
		end
	end
		
	--bind touch event
	controller:addEventListener("touch", controller)
	
	return controller
end

return Controller