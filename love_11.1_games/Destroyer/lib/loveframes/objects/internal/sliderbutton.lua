--[[------------------------------------------------
	-- L?ve Frames --
	-- Copyright 2012 Kenny Shields --
--]]------------------------------------------------

-- closebutton clas
sliderbutton = class("sliderbutton", base)
sliderbutton:include(loveframes.templates.default)

--[[---------------------------------------------------------
	- func: initialize()
	- desc: initializes the object
--]]---------------------------------------------------------
function sliderbutton:initialize(parent)

	self.type			= "sliderbutton"
	self.width 			= 10
	self.height 		= 20
	self.staticx		= 0
	self.staticy		= 0
	self.startx			= 0
	self.clickx			= 0
	self.starty			= 0
	self.clicky			= 0
	self.intervals		= true
	self.internal		= true
	self.down			= false
	self.dragging		= false
	self.parent			= parent
	
end

--[[---------------------------------------------------------
	- func: update(deltatime)
	- desc: updates the object
--]]---------------------------------------------------------
function sliderbutton:update(dt)
	
	local visible = self.visible
	local alwaysupdate = self.alwaysupdate
	
	if visible == false then
		if alwaysupdate == false then
			return
		end
	end
	
	self:CheckHover()
	
	local x, y 			= love.mouse.getPosition()
	local intervals 	= self.intervals
	local progress 		= 0
	local nvalue 		= 0
	local pvalue 		= self.parent.value
	local hover 		= self.hover
	local down 			= self.down
	local hoverobject 	= loveframes.hoverobject
	local parent 		= self.parent
	local slidetype 	= parent.slidetype
	local dragging 		= self.dragging
	
	if hover == false then
		self.down = false
	elseif hover == true then
		if hoverobject == self then
			self.down = true
		end
	end
	
	if down == false and hoverobject == self then
		self.hover = true
	end
	
	-- move to parent if there is a parent
	if self.parent ~= loveframes.base then
		self.x = self.parent.x + self.staticx
		self.y = self.parent.y + self.staticy
	end
	
	-- start calculations if the button is being dragged
	if dragging == true then
	
		-- calculations for horizontal sliders
		if slidetype == "horizontal" then
			
			self.staticx 		= self.startx + (x - self.clickx)
		
			progress 			= self.staticx/(self.parent.width - self.width)
			nvalue 				= self.parent.min + (self.parent.max - self.parent.min) * progress
			nvalue 				= loveframes.util.Round(nvalue, self.parent.decimals)
		
		-- calculations for vertical sliders
		elseif slidetype == "vertical" then
			
			self.staticy 		= self.starty + (y - self.clicky)
		
			local space 		= self.parent.height - self.height
			local remaining 	= (self.parent.height - self.height) - self.staticy
			local percent 		=  remaining/space
			
			nvalue 				= self.parent.min + (self.parent.max - self.parent.min) * percent
			nvalue 				= loveframes.util.Round(nvalue, self.parent.decimals)
			
		end
		
		-- 
		if nvalue > self.parent.max then
			nvalue = self.parent.max
		end
			
		if nvalue < self.parent.min then
			nvalue = self.parent.min
		end
		
		self.parent.value = nvalue
		
		if nvalue ~= pvalue and nvalue >= self.parent.min and nvalue <= self.parent.max then
			if self.parent.OnValueChanged then
				self.parent.OnValueChanged(self.parent, self.parent.value)
			end
		end
	
		loveframes.hoverobject = self
		
	end
	
	if slidetype == "horizontal" then
		if (self.staticx + self.width) > self.parent.width then
			self.staticx = self.parent.width - self.width
		end
		if self.staticx < 0 then
			self.staticx = 0
		end
	end
	
	if slidetype == "vertical" then
		if (self.staticy + self.height) > self.parent.height then
			self.staticy = self.parent.height - self.height
		end		
		if self.staticy < 0 then
			self.staticy = 0
		end
	end
	
	if self.Update then
		self.Update(self, dt)
	end

end

--[[---------------------------------------------------------
	- func: draw()
	- desc: draws the object
--]]---------------------------------------------------------
function sliderbutton:draw()
	
	local visible = self.visible
	
	if visible == false then
		return
	end
	
	local skins			= loveframes.skins.available
	local skinindex		= loveframes.config["ACTIVESKIN"]
	local defaultskin 	= loveframes.config["DEFAULTSKIN"]
	local selfskin 		= self.skin
	local skin 			= skins[selfskin] or skins[skinindex]
	local drawfunc		= skin.DrawSliderButton or skins[defaultskin].DrawSliderButton
	
	loveframes.drawcount = loveframes.drawcount + 1
	self.draworder = loveframes.drawcount
		
	if self.Draw ~= nil then
		self.Draw(self)
	else
		drawfunc(self)
	end
	
end

--[[---------------------------------------------------------
	- func: mousepressed(x, y, button)
	- desc: called when the player presses a mouse button
--]]---------------------------------------------------------
function sliderbutton:mousepressed(x, y, button)
	
	local visible = self.visible
	
	if visible == false then
		return
	end
	
	local hover = self.hover
	
	if hover == true and button == "l" then
	
		local baseparent = self:GetBaseParent()
		
		if baseparent and baseparent.type == "frame" then
			baseparent:MakeTop()
		end
		
		self.down = true
		self.dragging = true
		self.startx = self.staticx
		self.clickx = x
		self.starty = self.staticy
		self.clicky = y
		loveframes.hoverobject = self
		
	end
	
end

--[[---------------------------------------------------------
	- func: mousereleased(x, y, button)
	- desc: called when the player releases a mouse button
--]]---------------------------------------------------------
function sliderbutton:mousereleased(x, y, button)
	
	local visible = self.visible
	
	if visible == false then
		return
	end
	
	self.down = false
	self.dragging = false

end

--[[---------------------------------------------------------
	- func: MoveToX(x)
	- desc: moves the object to the specified x position
--]]---------------------------------------------------------
function sliderbutton:MoveToX(x)

	self.staticx = x
	
end

--[[---------------------------------------------------------
	- func: MoveToY(y)
	- desc: moves the object to the specified y position
--]]---------------------------------------------------------
function sliderbutton:MoveToY(y)

	self.staticy = y
	
end