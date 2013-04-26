Legend of Grimrock Scripting framework
==============

Reusable and modular scripting framework for Legend of Grimrock. It can be added to any existing LoG mod easily.
Core of the framework is a dynamic hook-framework (fw script entity). But it also contains other generally useful functions and script entities. 
fw script entity makes the usage of hooks much more versatile.

- Hooks can be created/removed or replaced in run time 
- Define hooks by entity type (eg. monsters, party or items) entity.name or entity.id. 
- Define multiple hooks of same type (eg. multiple party.onMove-hooks).

Documentation
https://sites.google.com/site/jkosgrimrock2/

Author: JKos

##CHANGES 2013-04-11

- GrimQ updated to newest version
- Added new features to timers-script entity
- init_module method is now called automatically when the module script entity is loaded 
- Bug fix: eg. fw.getById('champion_1') returned champion by slot instead of ordinal.

Examples of new features (this is runnable code)
```lua
function autoexec()

  --just a simple callback for demo purposes
	local callback = function(arg1) print(arg1) end
	
	
	-- timers.sequenceCall(sequence,callback,arguments)
	-- sequence: comma delimetered string or table of intervals
	-- callback: callback function
	-- arguments: callback arguments, a single variable or array of variables
	-- returns: extended timer object
	-- the timer is destroyed automatically after the execution
	local seq = timers.sequenceCall('1,2,3,4,2.5',callback,"sequenceCall") -- callback is called with 1,2,3,4 and 2.5 second intervals 
	
	-- remove the tick limit and make the timer loop the sequence forever
	-- by default it will be stopped and destroyed
	seq:setTickLimit(false)
	
	
	-- extendendTimer:addTickCallback(tickNumber,callback,arguments)
	-- binds the callback to a specific tick, handy with seqences but works with normal timers too
	-- callback receives the extended timer as a first argument
	seq:addTickCallback(2,function(self,arg) 
			print('This is printed on '..self.tick..'nd tick') 
		end
	)
	
	-- call the callback after delay seconds
	-- the timer is destroyed automatically after the execution
	local delayTimer = timers.delayCall(1,callback,"delayCall") 
	
	-- timers.repeatCall(interval,amount,instant,callback,arguments) 
	-- callback is called 4 times with 1 second interval, first call is instant
	-- the timer is destroyed automatically after the execution
	local repeatTimer = timers.repeatCall(1,4,true,callback,"repeatCall") 
	
	-- sequences can be set to any timer with extendedTimer:setSeq(sequence)
	-- and every method returns the extededTimer object so it's possible to chain the method calls  
	timers:create()
	:setSequence('10,20')
	:addCallback(function(self,arg) 
			print('Tick number: '..self.tick) 
			print('interval: '..self.interval)
		end
	)
	:activate()
	
	-- also onDestroy-hook added
	delayTimer.onDestroy = function(self) print(self.id..' is destroyed') end


end
```
