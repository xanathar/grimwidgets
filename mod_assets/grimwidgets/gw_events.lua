fw_addModule('gw_events',[[

tEvents = {}

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
	
	local id = eventScript.id

	if tEvents[id] == nil then
		-- Get the first event
		tEvents[id] = eventScript.states[1][1]
	end
	
	local state = tEvents[id]

	local descr = ""
	for name, stateInfo in pairs(eventScript.states) do
		if stateInfo[1] == state then
			descr = stateInfo[2]
			break
		end
	end
		
	-- we don't want to keep adding 60 boxes per seconds
	if gw.getElement("Dialog") == nil then
		gw.setDefaultColor({200,200,200,255})
		gw.setDefaultTextColor({255,255,255,255})

		-- It's not possible to use relative position for root element, 
		-- so let's calculate center of the screen automatically
		local bg = Dialog.create(-1, -1, 600, 400)

	    bg.dialog.text = descr
	
		-- Check if image is defined for this event
		local image_width = 0
		local image_height = 0
		if eventScript.image then
			image_width = eventScript.image_width
			image_height = eventScript.image_height
			if not image_width then
		 		image_width = 128
			end
		if not image_height then
			image_height = 128
		end

		local img = gw_image.create('img1', 0, 0, image_width, image_height, eventScript.image)
		img.marginTop = 30
		bg:addChild(img)
		img:setRelativePosition({'top','right'})
	end
		
	-- Ok, now write a text
	stateData = eventScript.states[state]

	printChoices(ctx, id, state, eventScript.actions, bg)

	gw.addElement(bg, 'gui')
	end
end

function printChoices(ctx, event_id, current_state, actions, window)
	number = 0
	for key1, action in pairs(actions) do
		if action[1] == current_state then
			-- action[2] = next_state, action[3] = text, action[4] = callback (optional)
			showButton(ctx, event_id, number, window, action[2], action[3], action[4])
			number = number + 1
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

function callback(button)
	local user_state = nil
	if (button.user_callback) then
		user_state = button:user_callback()
		if user_state then
			print("User callback return:"..user_state)
		else
			print("User callback (no returned value)")
		end
	end
	if user_state then 
		tEvents[button.event_id] = user_state
	else
		tEvents[button.event_id] = button.next_state
	end
	
	gw.removeElement("Dialog", 'gui')

	
end 

function showButton(ctx, event_id, number, window, next_state, text, userCallback)

	local x = 30 + 170*number
	local y = 350 
	local width = 150
	local height = 25
	
	-- print("Adding button "..next_state..", txt="..text.." callback="..type(userCallback).." event_id="..event_id)

	local button = gw_button3D.create("button_"..next_state, x, y, text, width, height)
	window:addChild(button)
	button.onClick = callback
	button.event_id = event_id
	button.next_state = next_state
	button.user_callback = userCallback
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
