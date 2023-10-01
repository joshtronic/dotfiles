local hyper = { 'ctrl', 'alt', 'cmd', 'shift' }

--------------------------------------------------------------------------------
-- Application Hot Keys
--------------------------------------------------------------------------------

local applicationHotKeys = {
  ['0'] = 'Finder',
  ['1'] = 'Terminal',
  ['2'] = 'Safari',
  ['3'] = 'Slack',
  ['4'] = 'Discord',
  ['5'] = 'Music',
  -- ['6'] = '',
  -- ['7'] = '',
  -- ['8'] = '',
  -- TODO: Probably need to `tell application` to those locations
  -- ['9'] = 'Downloads',
}

for key, application in pairs(applicationHotKeys) do
  hs.hotkey.bind(hyper, key, function()
    hs.application.launchOrFocus(application)
  end)
end

--------------------------------------------------------------------------------
-- Spotlight
--------------------------------------------------------------------------------

-- hs.hotkey.bind({}, 'f18', function()
--   hs.alert.show("Hello World!")
-- end)

--------------------------------------------------------------------------------
-- Window Snapping
--------------------------------------------------------------------------------

hs.window.animationDuration = 0

hs.hotkey.bind(hyper, 'a', function()
  local win = hs.window.focusedWindow()
  if not win then return end
  win:moveToUnit(hs.layout.left50)
end)

hs.hotkey.bind(hyper, 'd', function()
  local win = hs.window.focusedWindow()
  if not win then return end
  win:moveToUnit(hs.layout.right50)
end)

hs.hotkey.bind(hyper, 'w', function()
  local win = hs.window.focusedWindow()
  if not win then return end
  win:moveToUnit(hs.layout.maximized)
end)

-- Simulates a 'reset' of the window
hs.hotkey.bind(hyper, 's', function()
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

--[=====[
local homebrewIconWhite = hs.image
  .imageFromPath('~/.hammerspoon/images/homebrew-white.png')
  :setSize(hs.geometry.size(16, 16))

local homebrewMenubar = hs.menubar.new()
homebrewMenubar:setIcon(homebrewIconWhite)

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
    homebrewMenubar:setTitle(string.format(' %s', numOutdated))
    homebrewMenubar:setTooltip(outdated)
  else
    homebrewMenubar:setTitle(nil)
    homebrewMenubar:setTooltip('Up to date')
  end
end

updateHomebrewMenubar()
hs.timer.doEvery(3600, updateHomebrewMenubar)
--]=====]

--------------------------------------------------------------------------------
-- Slack Message Indicator
--------------------------------------------------------------------------------

--[=====[
local slackIconWhite = hs.image
  .imageFromPath('~/.hammerspoon/images/slack-white.png')
  :setSize(hs.geometry.size(16, 16))

local slackMenubar = hs.menubar.new()
slackMenubar:setIcon(slackIconWhite)

slackMenubar:setClickCallback(function()
  slackMenubar:setTitle(nil)
  hs.application.launchOrFocus('Slack')
end)

function updateSlackMenubar()
  local dock = hs.axuielement.applicationElement('Dock')
  local children = dock:attributeValue('AXChildren')

  if children and children[1] and children[1]:attributeValue('AXRole') == 'AXList' then
    local list = children[1]:attributeValue('AXChildren')
    for _, v in pairs(list) do
      if v:attributeValue('AXTitle') == 'Slack' then
        local label = v:attributeValue('AXStatusLabel') or '0'

        if label == '0' then
          slackMenubar:setTitle(nil)
        else
          slackMenubar:setTitle(string.format(' %s', label))
        end
      end
    end
  end
end

updateSlackMenubar()
hs.timer.doEvery(60, updateSlackMenubar)
--]=====]
