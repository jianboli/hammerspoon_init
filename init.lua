---------------------------------------------
-- Hot keys to quickly moving windows around
--------------------------------------------
-- move to occupy left half screen
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Left", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y
    f.w = max.w / 2
    f.h = max.h
    win:setFrame(f)
  end)

-- move to occupy left right screen
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Right", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x + (max.w / 2)
    f.y = max.y
    f.w = max.w / 2
    f.h = max.h
    win:setFrame(f)
  end)

-- move to occupy full screen
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Up", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w
  f.h = max.h
  win:setFrame(f)
end)

-- Move the occupy the bottom half screen
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Down", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y + (max.h / 2)
  f.w = max.w 
  f.h = max.h / 2
  win:setFrame(f)
end)

-- Toggle fullscreen
-- hs.hotkey.bind({"cmd", "alt", "ctrl"}, "f", function()
--  	local win = hs.window.focusedWindow()
-- 	win:toggleFullScreen()
--  end)

-- Send the window to next screen
hs.hotkey.bind({'alt', 'ctrl', 'cmd'}, 'n', function()
  -- get the focused window
  local win = hs.window.focusedWindow()
  -- get the screen where the focused window is displayed, a.k.a. current screen
  local screen = win:screen()
  -- compute the unitRect of the focused window relative to the current screen
  -- and move the window to the next screen setting the same unitRect 
  win:move(win:frame():toUnitRect(screen:frame()), screen:next(), true, 0)
end)
--------------------------------------------
-- The following actions is similiar but leave 
-- the windows other dimension unchanged
--------------------------------------------

-- Set the window width to half of the screen and move it to the left side
hs.hotkey.bind({"cmd", "ctrl"}, "Left", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.w = max.w / 2
    win:setFrame(f)
  end)

-- Set the window width to half of the screen and move it to the right side
hs.hotkey.bind({"cmd", "ctrl"}, "Right", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x + f.w
    f.w = max.w / 2
    win:setFrame(f)
  end)

-- Set the window height to half of the screen and move it to the top
hs.hotkey.bind({"cmd", "ctrl"}, "Up", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.y = max.y
  f.h = max.h / 2
  win:setFrame(f)
end)

-- Set the window height to half of the screen and move it to the bottom
hs.hotkey.bind({"cmd", "ctrl"}, "Down", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.h = max.h / 2
  f.y = max.y + f.h
  win:setFrame(f)
end)

-------------------------------------------------------
-- send window to a specific screen and then fullscreen
-------------------------------------------------------
local function sendToFullscreen()
  local win = hs.window.focusedWindow()
  local focusScreen = hs.screen{x=-1,y=0}
  
  local numScreens = #hs.screen.allScreens()
  if numScreens == 3 then
  	win:moveToScreen(focusScreen)
  end
  hs.timer.doAfter(0.2, function()
    win:setFullScreen(true)
  end)
end

hs.hotkey.bind({"cmd", "ctrl"}, "F", sendToFullscreen)

-------------------------------------------------------
-- send iTerm to a specific screen and then fullscreen
-------------------------------------------------------
hs.hotkey.bind({"cmd", "ctrl"}, "I", function()
	local win = hs.window.get("iTerm2")
  	local focusScreen = hs.screen{x=-1,y=0}
  
  	local numScreens = #hs.screen.allScreens()
  	if numScreens == 3 then
  		win:moveToScreen(focusScreen)
  	end
  	hs.timer.doAfter(0.2, function()
    	win:setFullScreen(true)
  	end)
end)

-----------------------------------------------
-- default layouts to fit in mulitple monitors 
-- if there are more than one
-----------------------------------------------
local positions = {
  leftTop = {x=0, y=0, w=0.5, h=0.5},
  leftBottom = {x=0, y=0.5, w=0.5, h=0.5},
  rightTop = {x=0.5, y=0, w=0.5, h=0.5},
  rightBottom = {x=0.5, y=0.5, w=0.5, h=0.5}
}

local appNames = {
  "Google Chrome",
  "VS Code @ FB",
  "Microsoft Outlook",
  "Workplace Chat",
  "iTerm",
  "Asana"
}

-- first by resolution then by x
local function screenCompare(a, b)
	-- first compare the area then the position
	aRect = a:fullFrame()
	bRect = b:fullFrame()
	if aRect['h']*aRect['w'] == bRect['h']*bRect['w'] then
		return aRect['x'] < bRect['x']
	end
	
	return aRect['h']*aRect['w'] < bRect['h']*bRect['w']
end

-- auto lanch the list apps
local function launchApps()
  for i, appName in ipairs(appNames) do
    hs.application.launchOrFocus(appName)
  end
end

-- apply a predefined layout based on the number of monitors
function switchLayout()
  local allScreens = hs.screen.allScreens()
  table.sort(allScreens, screenCompare)
  
  chrome_windows = hs.application.get('Google Chrome'):allWindows()

  local numScreens = #allScreens
  local layout = {}
  if numScreens == 1 then
    layout = layoutSingleScreen
  elseif numScreens == 2 then
  	layout = {
			{"VS Code @ FB", nil, allScreens[2], hs.layout.maximized, nil, nil},
			{"iTerm2", nil, allScreens[1], hs.layout.left50, nil, nil},
			{"Workplace Chat", nil, allScreens[1], hs.layout.left50, nil, nil},
			{"Asana", nil, allScreens[1], hs.layout.right50, nil, nil},
			{"Microsoft Outlook", nil, allScreens[1], positions.full, nil, nil},
	}
  -- Chrome always goes to the larger screen
	for k, g in pairs(chrome_windows) do
		layout[#layout+1] = {"Google Chrome", g, allScreens[2], hs.layout.maximized, nil, nil}
	end
  elseif numScreens == 3 then
    layout = {    
			{"VS Code @ FB", nil, allScreens[3], hs.layout.maximized, nil, nil},
			{"iTerm2", nil, allScreens[1], hs.layout.maximized, nil, nil},
			{"Workplace Chat", nil, allScreens[1], hs.layout.left50, nil, nil},
			{"Asana", nil, allScreens[1], hs.layout.right50, nil, nil},
			{"Microsoft Outlook", nil, allScreens[1], hs.layout.maximized, nil, nil},
		}
	-- Add all chrome windows to the most left largest screen
	for k, g in pairs(chrome_windows) do
		layout[#layout+1] = {"Google Chrome", g, allScreens[2], hs.layout.maximized, nil, nil}
	end
  end
  hs.layout.apply(layout)
end

-- create a keybinding for auto applying layouts
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "1", function()
  switchLayout()
end)

-------------------------------------------------
-- create a menu for easy of handeling: disabled
-------------------------------------------------
local menu = hs.menubar.new()

local function enableMenu()
  menu:setTitle("🖥")
  menu:setTooltip("No Layout")
  menu:setMenu({
      { title = "Launch Apps", fn = launchApps },
      { title = "Set Screen Layout", fn = switchLayout }
  })
end

-- enableMenu()

-------------------------------------------------
-- Some short key to bring up the applications
-------------------------------------------------
local hyper = {"cmd", "alt", "ctrl"}

local applicationHotkeys = {
  e = 'Google Chrome',
  f = 'Finder',
  t = 'iTerm',
  v = 'VS Code @ FB',
  w = 'Obsidian',
  s = 'Stocks',
  b = 'BBEdit',
  -- o = "Microsoft Outlook",
  a = "Asana",
  c = "Workplace Chat",
}

-- launch focus or rotate application
local function launchOrFocusOrRotate(app)
	local focusedWindow = hs.window.focusedWindow()
	-- If already focused, try to find the next window
	if focusedWindow and focusedWindow:application():name() == app then
		local appWindows = hs.application.get(app):allWindows()
		if #appWindows > 0 then
			-- It seems that this list order changes after one window get focused, 
			-- let's directly bring the last one to focus every time
			appWindows[#appWindows]:focus()
		else -- should not happen, but just to make sure
			hs.application.launchOrFocus(app)
		end
	else -- not focused
		hs.application.launchOrFocus(app)
	end
end


for key, app in pairs(applicationHotkeys) do
  hs.hotkey.bind(hyper, key, function()
    launchOrFocusOrRotate(app)
  end)
end
