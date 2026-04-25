local hyper = { 'ctrl', 'alt', 'cmd', 'shift' }

--------------------------------------------------------------------------------
-- App Launcher
--------------------------------------------------------------------------------

local applicationHotKeys = {
  ['1'] = 'Alacritty',
  ['2'] = 'Firefox',
  ['3'] = 'Slack',
  ['4'] = 'Discord',
  -- ['5'] = '',
  -- ['6'] = '',
  -- ['7'] = '',
  -- ['8'] = '',
  -- ['9'] = '',
  -- ['0'] = '',
}

for key, application in pairs(applicationHotKeys) do
  hs.hotkey.bind(hyper, key, function()
    hs.application.launchOrFocus(application)
  end)
end

--------------------------------------------------------------------------------
-- Window Snapping
--------------------------------------------------------------------------------

hs.window.animationDuration = 0

-- Left half
hs.hotkey.bind(hyper, 'a', function()
  local win = hs.window.focusedWindow()
  if not win then return end
  win:moveToUnit(hs.layout.left50)
end)

-- Right half
hs.hotkey.bind(hyper, 'd', function()
  local win = hs.window.focusedWindow()
  if not win then return end
  win:moveToUnit(hs.layout.right50)
end)

-- Maximize
hs.hotkey.bind(hyper, 'w', function()
  local win = hs.window.focusedWindow()
  if not win then return end
  win:moveToUnit(hs.layout.maximized)
end)

-- Simulates a 'reset' of the window
hs.hotkey.bind(hyper, 's', function()
  local win = hs.window.focusedWindow()
  if not win then return end
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h / 2

  win:setFrame(f)
  win:centerOnScreen(screen, true)
end)
