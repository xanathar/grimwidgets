-- base "class" for griwidget elements

fw_addModule('gw_element',[[
function create(id, x, y, width, height)
    local elem = {}
    elem.id = id
	elem.x = x
	elem.y = y
	elem.width = width
	elem.height = height
	elem.parent = nil
	elem.children = {}
	elem.addChild = _addChild
	elem.drawSelf = _drawNone
	elem.draw = _drawAll
	elem.onPress = nil
	elem.onClick = nil
	elem.firstMousePressPoint = nil
	elem.setRelativePosition = _setRelativePosition
	return elem
end

function drawNone()
end

-- draws whole element, including all its children
function _drawAll(self, ctx)
	self.drawSelf(self, ctx)
	if (self.onPress ~= nil) and (ctx.button(self.id, self.x, self.y, self.width, self.height)) then
		self:onPress()
	end
	gw_string.drawElementText(self,ctx)

	-- we manage onClick ourselves
	if (ctx.mouseDown(0)) then
		if (self.firstMousePressPoint == nil) and gw_util.isPointInBox(ctx.mouseX, ctx.mouseY, self.x, self.y, self.width, self.height) then
			self.firstMousePressPoint = { x = ctx.mouseX, y = ctx.mouseY }
		end
	else
		if (self.firstMousePressPoint ~= nil) then
			if (self.onClick ~= nil) and (gw_util.isPointInBox(ctx.mouseX, ctx.mouseY, self.x, self.y, self.width, self.height)) then
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

function _addChild(parent, child,id,x,y,width,height)
	if type(child) == 'string' then
		child = gw.create(child,id,x,y,width,height)
	end 

	table.insert(parent.children, child)
	child.parent = parent
	return child
end

-- sets elements relative position to parent
-- positions can be a string or table
-- possible values: top,middle,bottom,left,center,right
-- example 
function _setRelativePosition(e,positions)
	if not e.parent then return false end
	if type(positions) == 'string' then
		positions = {positions}
	end
	positions = help.tableToSet(positions)
	if positions.center then
		e.x = math.ceil((e.parent.width - e.width) / 2) 
	end
	if positions.left then
		e.x = 0
	end	
	if positions.right then
		e.x = e.parent.width - e.width 
	end		
	if positions.top then
		e.y = 0
	end
	if positions.bottom then
		e.y =  e.parent.height - e.height 
	end			
	if positions.middle then
		e.y = math.ceil((e.parent.height - e.height) / 2)
	end	
end
]])

