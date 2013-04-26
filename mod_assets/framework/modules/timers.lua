--[[timers.sequenceCall(sequence,callback,args)

local callback = function(arg1,arg2) print(arg1,arg2) end

timers.sequenceCall('1,2,3,4,2.5',callback,"argument") -- callback is called with 1,2,3,4 and 2.5 second intervals 

timers.delayCall(1,callback,"argument") -- callback is called 1 time after 1 seconds

timers.repeatCall(1,4,true,callback,"argument") -- callback is called 4 times with 1 second interval, first call is instant

-- arguments can be a sigle variable or array of variables

timers.repeatCall(1,4,true,callback,{"argument1","argument2"})
]]

fw_addModule('timers',[[
objects = {}
debug = false
count = 0

function _countUp()
	count = count + 1
end


-- spawn a new timer

function create(self,id,plevel)
 plevel = plevel or party.level
 id = id or 'fw_extended_timer_'..timers.count
 timers._countUp()

 local timerEntity = spawn('timer',plevel,0,0,1,id)
 id = timerEntity.id
 self.objects[id] = wrap(timerEntity)
 timerEntity:addConnector('activate','timers','callCallbacks')
 return self.objects[id]
end

-- find extended timer
function find(self,id)
	return self.objects[id]
end

-- simple delayed function call
function delayCall(interval,callback,args)
	return timers:create()
	:setTimerInterval(interval)
	:setTickLimit(1,true)
	:addCallback(callback,args,true)
	:activate()
end

-- repeated function call
function repeatCall(interval,count,instant,callback,args)
	return timers:create()
	:setTimerInterval(interval)
	:setTickLimit(count,true)
	:addCallback(callback,args,true)
	:setInstant(instant)
	:activate()

end

-- sequential function call
function sequenceCall(seq,callback,args)
	return timers:create()
	:setSequence(seq,true,true)
	:addCallback(callback,args,true)
	:activate()
end


function setLevels(self,levels)
	print('timers:setLevels is deprecated, you can remove the function call.')
end


-- create a wrapper object to timer passed as argument
function wrap(timer)
 local wrapper = {
    id = timer.id,
	level = timer.level,
    interval = 0,
    connectors = {},
	active = false,
	callbacks = {},
	tick = 0,
	addConnector = timers._addConnector,
	activate = timers._activate,
	deactivate = timers._deactivate,
	toggle = timers._toggle,	
	isActivated = timers._isActivated,		
	setInstant = timers._setInstant,
	setTimerInterval = timers._setTimerInterval,
	setConstant = timers._setConstant,
	destroy = timers._destroy,	
	addCallback = timers._addCallback,
	callCallbacks = timers.callCallbacks,
	setTickLimit = timers._setTickLimit,
	reset = timers._reset,
	setSequence = timers._setSequence,
	tickFilter = {},
	addTickCallback = timers._addTickCallback,
 }
 return wrapper
end

function _addConnector(self,paction,ptarget,pevent)
	self:addCallback(
		function(self,scriptId,functionName) 
			findEntity(scriptId)[functionName](self)
		end,
		{ptarget,pevent}
	)
	return self
end

function _activate(self)
	    self.active = true
		if self.isConstant then
			timers.objects[self.id..'_'..party.level]:activate()
		else
			findEntity(self.id):activate()
		end
		if self.instant then
			
			self:callCallbacks()
		end
		return self
end

function _deactivate(self)
	    self.active = false

		findEntity(self.id):deactivate()
		
		if (self.isConstant) then
			for l=1, getMaxLevels() do
				timers.objects[self.id..'_'..l]:deactivate()
			end
		end		
		if (type(self.onDeactivate) == 'function') then
			self.onDeactivate(self)
		end		
		return self
end

function _toggle(self)
		if (self.active) then 
			self:deactivate()
		else
			self:activate()
		end
		return self
end

function _isActivated(self)
		return self.active
end
-- If set, callbacks are called instantly after the activation of the timer.
function _setInstant(self,bool)
		self.instant = bool
		return self
end

function _setTimerInterval(self,interval)
	    self.interval = interval  + 0
		findEntity(self.id):setTimerInterval(self.interval)
		return self
end

function _setSequence(self,seq,runOnce,autodestroy)
	if type(seq) == 'string' then
		seq = help.split(seq,',')
	end
	self.seq = seq
	self:setTimerInterval(seq[1])
	if runOnce then
		self:setTickLimit(#seq,autodestroy)
	end
	return self
end

function _setConstant(self)
		self.isConstant = true
		timers.copyTimerToAllLevels(self)
		return self
end

function _destroy(self)
		findEntity(self.id):destroy()
		timers.objects[self.id] = nil
		if (self.isConstant) then
			for l=1,getMaxLevels() do
				timers.objects[self.id..'_'..l]:destroy()
			end
		end
		if (type(self.onDestroy) == 'function') then
			self.onDestroy(self)
		end		
		return self
end

function _reset(self,dontResetTick)
	if self.isConstant then
		print("Can't reset constant timer yet")
		return
	end
	self:deactivate()
	findEntity(self.id):destroy()
	local timerEntity = spawn('timer',self.level,0,0,1,self.id)
	timerEntity:addConnector('activate','timers','callCallbacks')
	if not dontResetTick then
		self.tick = 0
	end
	return self
end

function _addCallback(self,callback,callbackArgs,dontPassTimerAsArgument)
		if type(callbackArgs) ~= "table" then 
			callbackArgs = {callbackArgs}  
		end
		callbackArgs = callbackArgs or {}
		
		self.callbacks[#self.callbacks+1] = {callback,callbackArgs,dontPassTimerAsArgument}
		return self
end

function _addTickCallback(self,tick,callback,callbackArgs)
	self:addCallback(callback,callbackArgs)
	if not self.tickFilter[#self.callbacks] then self.tickFilter[#self.callbacks] = {} end
	self.tickFilter[#self.callbacks][tick] = true  
	return self
end

function _setTickLimit(self,limit,autodestroy)
		self.limit = limit
		self.autodestroy = autodestroy
		return self
end	

function callCallbacks(timerEntity)

	local extTimer = objects[timerEntity.id]
	extTimer.tick = extTimer.tick + 1
	
	for n,callback in ipairs(extTimer.callbacks) do
		local call = true
		if extTimer.tickFilter[n] and extTimer.tickFilter[n][extTimer.tick] == nil then
			call = false
		end
		if call then
			if callback[3] then
				callback[1](unpack(callback[2]))
			else
				callback[1](extTimer,unpack(callback[2]))
			end
		end
	end

	if extTimer.limit and extTimer.tick >= extTimer.limit then
		extTimer:deactivate()
		if (extTimer.autodestroy) then
			-- mark as destroyed
			extTimer.destroyed = true
		end		
	end 

   -- handle sequences
	if  extTimer.active and extTimer.seq then
		local interval = extTimer.seq[extTimer.tick+1]
		if interval ~= nil then
			extTimer:reset(true)
		else
			interval = extTimer.seq[1]
			extTimer:reset()
		end
		extTimer:setTimerInterval(interval)
		extTimer:activate()
		
	end		

	
	if (extTimer.destroyed) then
		if timers.debug then print('timer '..extTimer.id..' destroyed') end
		extTimer:destroy()
	end
end

function copyTimerToAllLevels(self)

		for l=1, getMaxLevels() do
		
			local t = timers:create(self.id..'_'..l,l)
			
			-- if interval is larger than 1 second
			-- use 0.1 seconds interval and count to actual interval*10
			-- this way the gap between level changes should stay minimal
			-- Thanks to Batty for the idea 
			if self.interval >= 1 then
				t:setTimerInterval(0.1)
				self.count = 0
				t:addCallback(
					function(self,timer_id,interval) 					
						local timer = timers.objects[timer_id]
						if (self.level == party.level) then
							timer.count = timer.count + 1
						else
							self:deactivate()
							timers:find(timer_id..'_'..party.level):activate()
						end
						if (timer.count == interval*10) then
							timer:callCallbacks()
							timer.count = 0
						end
		
					end,
					{self.id,self.interval}
				)
			else
				t:setTimerInterval(self.interval)
				t:addCallback(
					function(self,timer_id) 					
						local timer = timers.objects[timer_id]
						if (self.level == party.level) then	
							timer:callCallbacks()
						else
							self:deactivate()
							timers:find(timer_id..'_'..party.level):activate()
						end
					end,
					{self.id}
				)
			end
					
		end	
		self:deactivate()
end
]]
)