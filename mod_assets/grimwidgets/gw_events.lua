fw_addModule('gw_events',[[
-- processes events that are located in the same
-- location as party
function processEvents(ctx)
    local items=""
    for i in entitiesAt(party.level, party.x, party.y) do
        if i.name == "gw_event" then
            processEncounter(ctx, i)
	end
    end
end

function processEncounter(ctx, eventScript)
    if not sanityCheck(eventScript) then
        help.unfreezeWorld()
        return
    end
	help.freezeWorld()

	local state = eventScript.state
	if state == nil then
		state = 1
	end

	-- get width and height of the event box, use defaults if necessary
        local bg_width = eventScript.width
	local bg_height = eventScript.height
	if not bg_width then
	   bg_width = 600
	end
	if not bg_height then
	   bg_height = 400
	end

	-- we don't want to keep adding 60 boxes per seconds
	gw.removeElement("bg")

	-- It's not possible to use relative position for root element, 
	-- so let's calculate center of the screen
	local bg = gw_rectangle.create('bg', (ctx.width - bg_width)/2, 
				       (ctx.height - bg_height)/2, bg_width, bg_height)
	bg.color = {128, 128, 128, 192} -- use gray semi-transpartent background

	-- Check if image is defined for this event
	local image_width = 0
	local image_height = 0
	if eventScript.image then
	   image_width = eventScript.image_width
	   image_height = eventScript.image_height
	   if not image_width then
	      image_width = 120
	   end
	   if not image_height then
	      image_height = 120
	   end

	   local img = gw_image.create('img1', 0, 0, image_width, image_height, "mod_assets/images/example-image.dds")
	   bg:addChild(img)
	   img:setRelativePosition({'top','right'})
	end
		
	-- Ok, now write a text
	stateData = eventScript.states[state]

	local txt_width = bg_width - image_width
	local txt_height = 200

	local text1 = bg:addChild('rectangle','text1',0,0, txt_width, txt_height)
	text1:setRelativePosition{'top','left'}
	text1.color = {255, 255, 255}
	text1.text = stateData[2]
		
	local tbl = eventScript.actions
		
	local buttons_x = eventScript.buttons_x
	local buttons_y = eventScript.buttons_y
	local buttons_width = eventScript.buttons_width
		
	printChoices(ctx, state, tbl, buttons_x, buttons_y, buttons_width)

	gw.addElement(bg, 'gui')
end

function printChoices(ctx, current_state, states, x, y, width)
	for key1,value in pairs(states) do
		if value[1] == current_state then
			showButton(ctx, x, y, width, value[2], value[3])
			y = y + 30
		end
	end

end

function sanityCheck(e)
	if e.name ~= "gw_event" then
		return false
	end
    if e.states == nil then
		return false
	end
	
	if e.actions == nill then
		return false
	end
	
	if (e.enabled ~= true) then
		return false
	end
	
	return true

end

function showButton(ctx, x, y, width, text, callback)
    -- draw button1 with text
    ctx.color(128, 128, 128)
    ctx.drawRect(x, y, width, 20)
    ctx.color(255, 255, 255)
    ctx.drawText(text, x + 10, y + 15)
	local name="button"..x..y
	local height = 30
    if ctx.button("button1", x, y, width, height) then
		callback(ctx)
	end
end
]])

-- This new type of objects can be easily placed in the dungeon
-- using dungeon editor. Examples of such events are: meeting
-- a NPC, buying/selling in a shop, discussion with arch-enemy, etc.
cloneObject{
	name = "gw_event",
	baseObject = "script_entity",
	editorIcon = 148

}
