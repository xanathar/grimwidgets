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