-- This file has been generated by Dungeon Editor 1.3.6

--- level 1 ---

mapName("Unnamed")
setWallSet("dungeon")
playStream("assets/samples/music/dungeon_ambient.ogg")
mapDesc([[
################################
################################
################################
################################
################################
################################
################################
################################
################################
################################
################################
################################
################################
################################
##############...###############
##############...###############
##############...###############
################################
################################
################################
################################
################################
################################
################################
################################
################################
################################
################################
################################
################################
################################
################################
]])
spawn("starting_location", 15,15,0, "starting_location")
spawn("torch_holder", 15,14,0, "torch_holder_1")
	:addTorch()
spawn("script_entity", 2,0,0, "gw_debug")
	:setSource("-- this is just a placeholder for debugging purposes\
-- when debugging you can rename this script entity to gw and dopy paste \
-- the script from mod_assets/grimwidgets/gw.lua here. \
-- so the framwork will not load the script from lua file.\
-- same works with any dynamically loaded script entity.\
\
\
")
spawn("script_entity", 12,15,3, "debug")
	:setSource("\
-- draws size*size grid and shows mouse coordinates in upper left corner\
-- you can enable it by calling debug.grid(100), disable: debug.grid() \
-- currently works only in fullscreen mode because of g.width g.height bug\
\
function grid(size)\
\9if not size then\
\9\9gw.removeElement('grid')\
\9\9return\
\9end\
\9size = size or 100\
\9local grid = {}\
\9grid.id = 'grid'\
\9grid.size = size\
\9grid.draw = function(self,g)\
\9\9local h = math.ceil(g.height/self.size)\
\9\9local w = math.ceil(g.width/self.size)\
\9\9for x = 0,w do\
\9\9\9g.drawRect(x*self.size,0,1,g.height)\
\9\9end\
\9\9for y = 0,h do\
\9\9\9g.drawRect(0,y*self.size,g.width,1)\
\9\9end\9\9\
\9\9g.drawText('x: '..g.mouseX..', y:'..g.mouseY,20,20)\
\9\9g.drawText('g.width - '..g.width - g.mouseX..', g.height - '..g.height - g.mouseY,20,40)\
\9end\
\9gw.addElement(grid)\
end\
\
function debugGrid()\
\9grid(100)\
end")
spawn("wall_button", 14,15,3, "wall_button_1")
	:addConnector("toggle", "debug", "debugGrid")
spawn("dungeon_wall_text", 14,15,3, "dungeon_wall_text_1")
	:setWallText("Enable mouse grid")
spawn("gw_event", 16,16,2, "gw_event_1")
	:setSource("-- is this event enabled?\
enabled = true\
\
-- name of the imeage to show\
image = \"mod_assets/images/example-image.dds\"\
\
-- todo: the following x,y coords are temporary.\
--       They should be calculated automatically.\
\
-- image position\
image_x = 40\
image_y = 60\
\
-- text description position\
text_x = 220\
text_y = 60\
\
-- buttons position\
buttons_x = 220\
buttons_y = 160\
buttons_width = 200\
\
-- initial state\
state = 1\
\
-- functions called after specific buttons being pressed\
function onHeal()\
    hudPrint(\"Healing!\")\
    state = 2\
end\
\
function onTalk()\
    hudPrint(\"Dwarf is in too much pain to talk.\")\
end\
\
function onLeave()\
    enabled = false\
end\
\
function onHealed()\
    hudPrint(\"He is healed already!\")\
end\
\
-- defines states. Each entry must have exactly two columns:\
-- first is state number, the second is description shown.\
states = {\
  { 1, \"An injured dwarf lies on the ground before you,\\n\" ..\
       \"nearly unconscious from his wounds.\" },\
  { 2, \"The healed dwarf is happy.\" }\
}\
\
-- defines possible actions in each state. Each entry has\
-- 3 values. First is state number. Second is action name\
-- (will be printed on a button). The third is a function\
-- that will be called when action is taken (i.e. button\
-- is pressed).\
actions = {\
  { 1, \"tend his wounds\", onHeal },\
  { 1, \"talk\", onTalk },\
  { 1, \"leave\", onLeave},\
  { 2, \"healed\", onHealed}\
}\
")
spawn("script_entity", 29,31,2, "spell_book")
	:setSource("-- For testing/developement purposes\
-- I hope that this case is complex enough to show the possible flaws on grimwigets.\
\
spells = {}\
offset = {\
\9x=20,\
\9y=20,\
\9line_h = 20,\
}\
runeMap = {\
\9A='rune1_fire',\
\9B='rune2_death',\
\9C='rune3_air',\
\9D='rune4_spirituality',\
\9E='rune5_balance',\
\9F='rune6_physicality',\
\9G='rune7_earth',\
\9H='rune8_life',\
\9I='rune9_water'\
}\
function activate()\
\
\
end\
\
function setSpells(pspells)\
\9spells = {}\
\9i = 1\
\9for spellName,def in pairs(pspells) do\
\9\9table.insert(spells,i,def)\
\9\9i = i + 1\
\9end\
end\
\
function drawSpellBook(self,g,champion)\
\9if champion and champion:getClass() ~= 'Mage' then\
\9\9gw.removeElement('spell_book_runes','skills')\
\9\9return\
\9end\
\9local x = spell_book.offset.x\
\9local y = spell_book.offset.y\
\9\
\9g.color(255,255,255,200)\
\9g.drawImage(\"mod_assets/textures/book_900.tga\",x,y)\
\9\
\9g.font('medium')\
\9local row = 1\
\9for name,spell in pairs(spells) do\
\9\9if g.button(spell.name..'_b',x,y + row * 20,300,20) then\
\9\9\9if (spell.runes) then\
\9\9\9\9local rune_images = {}\
\9\9\9\9\
\9\9\9\9for i=1,#spell.runes do\
\9\9\9\9\9local runeChar = string.sub(spell.runes,i,i)\
\9\9\9\9\9rune_images[i] = 'mod_assets/textures/'..runeMap[runeChar]..'.tga'\
\9\9\9\9end\
\9\9\9\9\
\9\9\9\9local runes = {\
\9\9\9\9\9id='spell_book_runes',\
\9\9\9\9\9images = rune_images,\
\9\9\9\9\9description = spell.description \
\9\9\9\9}\
\9\9\9\9runes.draw = function(self,g,champ)\
\9\9\9\9\9g.font('small')\
\9\9\9\9\9for i,imagePath in ipairs(self.images) do\
\9\9\9\9\9\9g.drawImage(imagePath,500+100*i,200)\
\9\9\9\9\9end\
\9\9\9\9\9g.drawText(self.description,500,300)\
\9\9\9\9end\
\9\9\9\9gw.removeElement('spell_book_runes','skills')\
\9\9\9\9gw.addElement(runes,'skills')\
\9\9\9\9\
\9\9\9end\
\9\9\9\
\9\9end\9\9\
\9\9\
\9\9g.color(237,175,135,255)\
\9\9g.drawRect(x + 30 ,y+row*20,19,19)\
\9\9\
\
\9\9g.color(250,250,250,255)\
\9\9g.drawText(spell.uiname,x + 50, y + 20 + row*20)\
\9\9row = row + 1\
\9end\
end\
\
function autoexec()\
\9-- testing\
\9setSpells{\
\9\9{name='fireburst',uiname='Fireburst',runes='A',description='Caster creates a quick burst of fire in front of him'},\
\9\9{name='ice_shards',uiname='Ice Shards',runes='GI',description='Caster shoots a flurry of ice shards in front of him'}\
\9}\
\9\
\9\9\
\9local e = {}\
\9e.id = 'spell_book_mage'\
\9e.draw = spell_book.drawSpellBook\
\9--gw.setKeyHook('m',true,e.draw)\
\9gw.addElement(e,'skills')\
end\
")
spawn("script_entity", 28,31,2, "compass")
	:setSource("-- This example draws a compass as a GUI element. Depending on which\
-- activation mode is chosen, it can be visible all time, toggled\
-- with 'c' key or shown only when 'c' is pressed.\
\
-- draws actual compass\
-- this function is called when compass is visible all time\
function drawCompass(self, g)\
\9local x = 10\
\9local y = g.height - 200\
\9\
\9local dir = string.sub(\"NESW\", party.facing + 1, party.facing + 1)\
\9g.drawImage(\"mod_assets/textures/compass_full_\"..dir..\".tga\", x, y)\
end\
\
-- this is a simple wrapper function that is called as key press\
-- hook. It calls drawCompass function.\
function callback(g)\
\9drawCompass(self, g)\
end\
\
function autoexec()\
\9local e = {}\
\9e.id = 'compass'\
\9e.draw = drawCompass\
\9e.callback = callback\
\9\
\9-- uncomment this to enabled/disable compass by pressing C\
\9gw.setKeyHook('c', true, e.callback)\
\9\
\9-- Uncomment this to show compass by pressing C\
\9-- gw.setKeyHook('c', false, e.callback)\
\9\
\9-- Uncomment this to have compass permanently visible\
\9-- gw.addElement(e,'gui')\
end")
spawn("wall_button", 14,16,3, "wall_button_2")
	:addConnector("toggle", "script_entity_1", "drawExample")
spawn("script_entity", 12,16,2, "script_entity_1")
	:setSource("-- This function showcases how gwElements may be stacked together\
function drawExample()\
\
\9local rect1 = gw.createRectangle('rect1', 100, 50, 400, 150)\
\9rect1.color = {255, 255, 0}\
\9\
\9local button1 = gw.createButton3D('button1', 70, 10, \"3D-ABCDEFGHIJKLMNOPQRSTUVWXYZ\")\
\9button1.onClick = function(self) print(self.id..' clicked') end\
\9rect1:addChild(button1)\
\9\
\9local button2 = gw.createButton('button2', 70, 40, \"abcdefghijklmnopqrstuvwxyz\")\
\9button2.color = button1.color\
\9button2.onPress = function(self) print(self.id..' clicked') end\
\9rect1:addChild(button2)\
\9\
\9local button3 = gw.createButton('button3', 70, 70, \"1234567890\")\9\
\9button3.color = button1.color\
\9button3.onPress = function(self) print(self.id..' clicked') end\
\9rect1:addChild(button3)\
\9\
\9\
\9-- Create directly to parent example\
\9local button4 = rect1:addChild('Button','button4', 70, 100, \"!@#$%^&*()-,.'\")\
\9button4.color = button1.color\
\9button4.onPress = function(self) print(self.id..' clicked') end\
\9\
\9rect2 = rect1:addChild('Rectangle','rect2', 10, 10, 50, 50)\
\9rect2.color={0, 0, 255}\
\9\
\9local rect3 = rect2:addChild('Rectangle','rect3', 10, 10, 30, 30) -- rect3 in rect2, which is in rect1\
\9rect3.color = {255, 0, 0}\
\9rect3.onPress = function(self) print('rectangles can be clicked too') end\
\
\
\9gw.addElement(rect1, 'gui')\
end\
")
spawn("dungeon_wall_text_long", 14,16,3, "dungeon_wall_text_long_1")
	:setWallText("Shows gwElements (several gui elements\
that are hierarchically organized)")
spawn("script_entity", 0,0,1, "logfw_init")
	:setSource("spawn(\"LoGFramework\", party.level,1,1,0,'fwInit')\
fwInit:open() \
function main()\
   fw.debug.enabled = false\
   fwInit:close()\
end")
