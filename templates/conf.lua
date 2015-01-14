function love.conf(t)
--	t.identity = "save" -- name of the save directory
--	t.icon = "icon.png" -- icon file
	t.version = "0.9.1" -- version of love the game was made for
	t.window.width, t.window.height = 1280, 720
	t.window.minwidth, t.window.minheight = 1280, 720
	t.window.vsync = true --vertical sync
	t.modules.keyboard = true
	t.modules.joystick = false -- turn on for joystick
	t.modules.physics = false -- turn on the modules for physics
