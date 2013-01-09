
-- import the framework if it's not loaded
if not fw_loadModule then
	import('mod_assets/framework/framework.lua')
end
function gw_loadModule(name)
	import('mod_assets/grimwidgets/'..name..'.lua')
end


-- Basic hooks for GUI related calls (GUI, inventory, skills, stats)
cloneObject{
	name='party',
	baseObject='party',
	onDrawGui = function(g)
	   gw.draw(g)
	end, 
	onDrawInventory = function(g,champ)
	   gw.drawInventory(g,champ)
	end, 
	onDrawSkills = function(g,champ)
	   gw.drawSkills(g,champ)
	end, 
	onDrawStats  = function(g,champ)
	   gw.drawStats(g,champ)
	end	
}

gw_loadModule('gw')
gw_loadModule('gw_events')