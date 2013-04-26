fw_addModule('fw_default_hooks',[[
function init_module()
-- custom hooks
	-- item:onPickUp
	-- usage example fw.setHook('potion_poison.test.onPickUp',function(self,party) print(self.name) end)
	fw.addHooks('party','CustomItemOnPickup',
		{
			onPickUpItem = function(self,item)
				return fw.executeEntityHooks('items','onPickUp',item,self)
			end
		}
	)
--Vanilla hooks copied from asset pack lua-files ++

	fw.addHooks('spider','default',
		{
		  onDealDamage = function(self, champion, damage)
			if math.random() <= 0.3 then
			  champion:setConditionCumulative("poison", 30)
			end
		  end
		}
	)

	fw.addHooks('ogre','default',
		{
		  onDealDamage = function(self, champion, damage)
			party:shakeCamera(0.5, 0.3)
			party:playScreenEffect("damage_screen")
		  end
		}
	)

	fw.addHooks('tentacles','default',{  
		onDealDamage = function(self, champion, damage)
			if math.random() <= 0.2 then
			  champion:setConditionCumulative("paralyzed", 10)
			end
		  end
		}
	)

	fw.addHooks('shrakk_torr','default',{
		onDealDamage = function(self, champion, damage)
			if math.random() <= 0.35 then
			  champion:setConditionCumulative("diseased", 30)
			end
		  end
		}
	)

	fw.addHooks('warden','default',{
		onDealDamage = function(self, champion, damage)
			party:shakeCamera(0.5, 0.3)
			party:playScreenEffect("damage_screen")
		  end
		}
	)

	fw.addHooks('green_slime','default',{
		onDealDamage = function(self, champion, damage)
			if math.random() <= 0.2 then
			  champion:setConditionCumulative("diseased", 30)
			end
		  end
		}
	)
	fw.addHooks('rotten_pitroot_bread','default',{
		onUseItem = function(self, champion)
			playSound("consume_food")
			if math.random() < 0.5 then
				champion:setCondition("diseased", 20)
			end
			champion:modifyFood(250)
			return true
		end
		}
	)
	fw.addHooks('tome_health','default',{
		onUseItem = function(self, champion)
			playSound("level_up")
			hudPrint(champion:getName().." gained Health +25.")
			champion:modifyStatCapacity("health", 25)
			champion:modifyStat("health", 25)
			return true
		end
		}
	)
	fw.addHooks('tome_wisdom','default',{
		onUseItem = function(self, champion)
			playSound("level_up")
			hudPrint(champion:getName().." gained 5 skillpoints.")
			champion:addSkillPoints(5)
			return true
		end
		}
	)		
	fw.addHooks('tome_fire','default',{
		onUseItem = function(self, champion)
			playSound("level_up")
			hudPrint(champion:getName().." gained Resist Fire +10.")
			champion:trainSkill("fire_magic", 3, true)
			champion:modifyStatCapacity("resist_fire", 10)
			champion:modifyStat("resist_fire", 10)
			return true
		end
		}
	)

	fw.addHooks('water_flask','default',{		
		onUseItem = function(self, champion)
			playSound("consume_potion")
			return true
		end
		}
	)

	fw.addHooks('potion_healing','default',{
		onUseItem = function(self, champion)
			playSound("consume_potion")
			champion:modifyStat("health", 75)
			return true
		end
		}
	)	
	fw.addHooks('potion_energy','default',{
		onUseItem = function(self, champion)
			playSound("consume_potion")
			champion:modifyStat("energy", 75)
			return true
		end
		}
	)	
	fw.addHooks('potion_poison','default',{
		onUseItem = function(self, champion)
			playSound("consume_potion")
			champion:setConditionCumulative("poison", 50)
			return true
		end
		}
	)	
	fw.addHooks('potion_cure_poison','default',{
		onUseItem = function(self, champion)
			playSound("consume_potion")
			champion:setCondition("poison", 0)
			return true
		end
		}
	)	
	fw.addHooks('potion_cure_disease','default',{
		onUseItem = function(self, champion)
			playSound("consume_potion")
			champion:setCondition("diseased", 0)
			champion:setCondition("paralyzed", 0)
			return true
		end
		}
	)	
	fw.addHooks('potion_rage','default',{
		onUseItem = function(self, champion)
			playSound("consume_potion")
			champion:setCondition("rage", 60)
			return true
		end
		}
	)	
	fw.addHooks('potion_speed','default',{
		onUseItem = function(self, champion)
			playSound("consume_potion")
			champion:setCondition("haste", 50)
			return true
		end
		}
	)	
end	
]])
