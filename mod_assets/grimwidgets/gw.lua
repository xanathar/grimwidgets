fw_addModule('gw',[[
keyHooks = {}
elements = {
	gui = {},
	stats = {},
	skills = {},
	inventory = {}
}


function addElement(element,hookName)
	hookName = hookName or 'gui'
   	table.insert(elements[hookName],element)
end

function removeElement(id,hookName)
	hookName = hookName or 'gui'
	for i,elem in ipairs(elements[hookName]) do
		if elem.id == id then
			table.remove(elements[hookName],i)
			return
		end
	end
end

function drawElements(g,hookName,champion)
	hookName = hookName or 'gui'
	for id,element in pairs(elements[hookName]) do
		element:draw(g,champion)
	end
end

function draw(g)

	processKeyHooks(g)
	drawElements(g,'gui')
	gw_events.processEvents(g)
end


function drawInventory(g,champ)
	drawElements(g,'inventory',champ)
end

function drawStats(g,champ)
	drawElements(g,'stats',champ)
end

function drawSkills(g,champ)
	drawElements(g,'skills',champ)
end

function setKeyHook(key,ptoggle,pcallback)
	keyHooks[key] = {callback=pcallback,toggle=ptoggle,active=false}
end

function processKeyHooks(g)
	for key,hookDef in pairs(keyHooks) do
		if hookDef.toggle then
			-- toggle key state and add small threshold so the state doesn't change immediately
			if not keyToggleThresholdTimer and g.keyDown(key) then
				hookDef.active = not hookDef.active
				local t = spawn('timer',party.level,0,0,1,'keyToggleThresholdTimer')
				t:setTimerInterval(0.3)
				t:addConnector('activate','gw','destroyKeyToggleThresholdTimer')
				t:activate()
			end
			if hookDef.active then
				hookDef.callback(g)
			end	
		elseif g.keyDown(key) then
			hookDef.callback(g)
		end
	end
end

function destroyKeyToggleThresholdTimer()
	keyToggleThresholdTimer:destroy()
end


--- gwElements utiltity functions


-- draws whole element, including all its children
function drawAll(self, ctx)
	self.drawSelf(self, ctx)
	if (self.onPress ~= nil) and (ctx.button(self.id, self.x, self.y, self.width, self.height)) then
		self:onPress()
	end

	-- we manage onClick ourselves
	if (ctx.mouseDown(0)) then
		if (self.firstMousePressPoint == nil) and isPointInBox(ctx.mouseX, ctx.mouseY, self.x, self.y, self.width, self.height) then
			self.firstMousePressPoint = { x = ctx.mouseX, y = ctx.mouseY }
		end
	else
		if (self.firstMousePressPoint ~= nil) then
			if (self.onClick ~= nil) and (isPointInBox(ctx.mouseX, ctx.mouseY, self.x, self.y, self.width, self.height)) then
				self:onClick()
			end
			self.firstMousePressPoint = nil
		end
	end

	for key,child in pairs(self.children) do
		child.x = child.x + self.x -- calculate proper offset
		child.y = child.y + self.y
		child.draw(child, ctx) -- draw child element
		child.x = child.x - self.x -- revert back to normal coordinates
		child.y = child.y - self.y
	end
end

function drawNone()
end

function drawRect(self, ctx)
	if (self.color) then
    	ctx.color(self.color[1], self.color[2], self.color[3], self.color[4])
	end
    ctx.drawRect(self.x, self.y, self.width, self.height)
end

function rgb2yuv(rgb)
	return {
		0.299 * rgb[1] + 0.587 * rgb[2] + 0.114 * rgb[3] ,
		-0.147 * rgb[1] - 0.289 * rgb[2] + 0.436 * rgb[3],
		0.615 * rgb[1] - 0.515 * rgb[2] - 0.1 * rgb[3],
		rgb[4]
	}
end

function normalizeColorComponent(c)
	return math.max(0, math.min(255, math.floor(c + 0.5)))
end

function yuv2rgb(yuv)
	return {
		normalizeColorComponent(yuv[1] + 1.402 * yuv[3]),
		normalizeColorComponent(yuv[1] - 0.344 * yuv[2] - 0.714 * yuv[3]),
		normalizeColorComponent(yuv[1] + 1.772 * yuv[2]),
		yuv[4]
	}
end

function changeBrightness(color, factor)
	local yuv = rgb2yuv(color)
	yuv[1] = factor * yuv[1]
	return yuv2rgb(yuv)
end

function isPointInBox(px, py, bx, by, bw, bh)
	return (px >= bx) and (px <= bx + bw) and (py >= by) and (py <= by + bh)
end

function setColor(ctx, color)
	ctx.color(color[1], color[2], color[3], color[4])
end

function resetColor(ctx)
	ctx.color(255, 255, 255, 255)
end


function drawBevel(self, ctx, protruding, fillbutton, highlight)
	local color = defaultValue(self.color, {128, 128,128})
	local light, dark, fill
	
	if (protruding) then
		light = changeBrightness(color, 1.4)
		dark = changeBrightness(color, 0.6)
	else
		light = changeBrightness(color, 0.6)
		dark = changeBrightness(color, 1.4)
	end
	
	
	if (highlight) then
		fill = changeBrightness(color, 1.2)
	else
		fill = color
	end
	
	if (fillbutton) then
		setColor(ctx, fill)
		ctx.drawRect(self.x, self.y, self.width, self.height)
	end	
	
	setColor(ctx, light)
	ctx.drawRect(self.x, self.y, self.width, 2)
	ctx.drawRect(self.x, self.y, 2, self.height)

	setColor(ctx, dark)
	ctx.drawRect(self.x, self.y + self.height - 2, self.width, 2)
	ctx.drawRect(self.x + self.width - 2, self.y, 2, self.height)
end



function addChild(parent, child,id,x,y,width,height)
	if type(child) == 'string' then
		child = gw['create'..child](id,x,y,width,height)
	end 

	table.insert(parent.children, child)
	return child
end

function createElement(id, x, y, width, height)
    local elem = {}
    elem.id = id
	elem.x = x
	elem.y = y
	elem.width = width
	elem.height = height
	elem.parent = nil
	elem.children = {}
	elem.addChild = addChild
	elem.drawSelf = drawNone
	elem.draw = drawAll
	elem.onPress = nil
	elem.onClick = nil
	elem.firstMousePressPoint = nil
	return elem
end

function defaultValue(curvalue, defvalue)
	if (curvalue == nil) then
		return defvalue
	else
		return curvalue
	end
end

function makeButton(elem,callback)	

end

function createRectangle(id, x, y, width, height)
	local elem = createElement(id, x, y, width, height)
	elem.drawSelf = drawRect
	return elem
end

function drawButton(self, ctx)
	drawRect(self, ctx)
	resetColor(ctx)
	ctx.drawText(self.text, self.x + 5, self.y + 13 + 5)
end

function drawButton3D(self, ctx)
	local hl = isPointInBox(ctx.mouseX, ctx.mouseY, self.x, self.y, self.width, self.height)
	local down = ctx.mouseDown(0) and hl

	drawBevel(self, ctx, not down, true, hl)
	
	resetColor(ctx)
	ctx.drawText(self.text, self.x + 5, self.y + 13 + 5)
end

function stringWidth(text)
	local len = 0
	for i = 1, string.len(text) do
		local char = string.sub(text, i, i)
		if char>='A' and char<='Z' then
			len = len + 12 -- capital letters
		elseif char>='a' and char<='z' then
			len = len + 9 -- small letters
		elseif char == ' ' then
			len = len + 5 -- space
		elseif char>='0' and char<='9' then
			len = len + 9
		elseif char>='!' and char<='/' then
			len = len + 8
		else
			len = len + 10		
		end
	end
	return len
end

function createButton(id, x, y, text)
	local width = stringWidth(text)
	local elem = createRectangle(id, x, y, width, 23)
	elem.text = text
	elem.drawSelf = drawButton
	return elem
end
 
function createButton3D(id, x, y, text, width, height, color)
	width = defaultValue(width, stringWidth(text))
	height = defaultValue(height, 27)
	
	local elem = createRectangle(id, x, y, width, height)
	elem.text = text
	elem.drawSelf = drawButton3D
	elem.color = defaultValue(color, { 128, 128, 128 })
	return elem
end
]])