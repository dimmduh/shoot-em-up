--usefull functions
function p(t)
	print( t )
end

--@see http://lua-users.org/wiki/MathLibraryTutorial
math.randomseed( os.time() )

_W, _H = display.contentWidth, display.contentHeight
fps = 30

require "sprite"
require ("inc/utils");
require ("inc/controller");
require ("inc/turel");
require ("inc/bullet");
require ("inc/worm");

utils.showFps();

local controller_radius = 100
local controller = Controller:new({x = (10 + controller_radius), y = (_H - 10 - controller_radius), radius = controller_radius})
	


--background
local bg = display.newImage("img/bg.png", 0, 0)
bg:toBack()

--create turel
turel = Turel:new({x = _W * 0.5, y = _H * 0.5})

--attach controller for controling turel rotation
controller:attach(turel)

--create first worm
worms = {}
local worm = Worm:new({
	targetX = turel.x,
	targetY = turel.y
})

table.insert(worms, worm)