--------------------------------------------------------------------------------
-- Application Hot Keys
--------------------------------------------------------------------------------

local applicationHotKeys = {
  ['1'] = 'Finder',
  ['2'] = 'Terminal',
  ['3'] = 'Safari',
  ['4'] = 'Slack',
  ['5'] = 'DataGrip',
  ['6'] = 'Spotify',
  -- ['7'] = '',
  -- ['8'] = '',
  -- TODO: Probably need to `tell application` to those locations
  -- ['9'] = 'Downloads',
  -- ['0'] = 'Trash',
}

for key, application in pairs(applicationHotKeys) do
  hs.hotkey.bind({ 'cmd' }, key, function()
    hs.application.launchOrFocus(application)
  end)
end

--------------------------------------------------------------------------------
-- Window Snapping
--------------------------------------------------------------------------------

hs.window.animationDuration = 0

hs.hotkey.bind({ 'cmd' }, 'Left', function()
  local win = hs.window.focusedWindow()
  if not win then return end
  win:moveToUnit(hs.layout.left50)
end)

hs.hotkey.bind({ 'cmd' }, 'Right', function()
  local win = hs.window.focusedWindow()
  if not win then return end
  win:moveToUnit(hs.layout.right50)
end)

hs.hotkey.bind({ 'cmd' }, 'Up', function()
  local win = hs.window.focusedWindow()
  if not win then return end
  win:moveToUnit(hs.layout.maximized)
end)

-- Simulates a 'reset' of the window
hs.hotkey.bind({ 'cmd' }, 'Down', function()
  local win = hs.window.focusedWindow()
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

--------------------------------------------------------------------------------
-- Homebrew Update Indicator
--------------------------------------------------------------------------------

local homebrewMenubar = hs.menubar.new()

homebrewMenubar:setClickCallback(function()
  hs.applescript.applescript([[
    tell application "Terminal"
      do script "brew upgrade"
      activate
    end tell
  ]])
end)

function updateHomebrewMenubar()
  local outdated = hs.execute('/opt/homebrew/bin/brew outdated')
  local _, numOutdated = outdated:gsub('\n', '\n')

  if numOutdated > 0 then
    homebrewMenubar:setTitle(string.format('🍺 %s', numOutdated))
    homebrewMenubar:setTooltip(outdated)
  else
    homebrewMenubar:delete()
  end
end

updateHomebrewMenubar()
hs.timer.doEvery(3600, updateHomebrewMenubar)
