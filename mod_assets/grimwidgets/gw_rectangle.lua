fw_addModule('gw_rectangle',[[
function create(id, x, y, width, height)
	local elem = gw_element.create(id, x, y, width, height)
	elem.drawSelf = _draw
	return elem
end

function _draw(self, ctx)
	if (self.color) then
    	ctx.color(self.color[1], self.color[2], self.color[3], self.color[4])
	end
    ctx.drawRect(self.x, self.y, self.width, self.height)
end

]])