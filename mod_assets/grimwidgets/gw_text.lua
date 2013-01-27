fw_addModule('gw_text',[[
function create(id, x, y, width, height, text)
	local elem = gw_element.create(id, x, y, width, height)
	elem.text = text
	--elem.drawSelf = function() end
	return elem
end
]])
