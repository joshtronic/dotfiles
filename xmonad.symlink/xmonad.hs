{-# LANGUAGE OverloadedStrings #-}

import System.IO
import System.Exit

import XMonad
import XMonad.Config.Gnome
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
-- import XMonad.Hooks.SetWMName

-- import XMonad.Layout.NoBorders
-- import XMonad.Layout.Spacing
-- import XMonad.Layout.Grid
-- import XMonad.Layout.Spiral
-- import XMonad.Layout.Tabbed
-- import XMonad.Layout.PerWorkspace
-- import XMonad.Layout.Named

import XMonad.Util.Run(spawnPipe)
-- import XMonad.Util.EZConfig(additionalKeys)

import qualified XMonad.StackSet          as W
import qualified Data.Map                 as M
import qualified DBus.Client.Simple       as D
import qualified Codec.Binary.UTF8.String as UTF8

-- mod#Mask
-- 1 = Left Alt (Conflicts with Gnome3 Panel)
-- 2 = ???
-- 3 = Right Alt
-- 4 = "Windows"
myModMask = mod1Mask

myWorkspaces = ["1","2","3","4"] ++ map show [5..9]

-- xprop | grep WM_CLASS
myManageHook :: [ManageHook]
myManageHook =
    [ resource  =? "chromium-browser"     --> doShift "2"
    , resource  =? "desktop_window"       --> doIgnore
    , className =? "Firefox"              --> doShift "2"
    , className =? "Empathy"              --> doShift "2"
    , className =? "Galculator"           --> doCenterFloat
    , className =? "Gimp"                 --> doFloat
    , className =? "Google-chrome"        --> doShift "2"
    , resource  =? "gpicview"             --> doFloat
    , resource  =? "kdesktop"             --> doIgnore
    , className =? "MPlayer"              --> doFloat
    , resource  =? "nm-connection-editor" --> doFloat
    , className =? "Rhythmbox"            --> doShift "4"
    , className =? "Banshee"              --> doShift "4"
    , className =? "Agave"                --> doCenterFloat
    , className =? "Gmail - Inbox"        --> doShift "3"]

myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
  -- Start a terminal.  Terminal to start is specified by myTerminal variable.
  [ ((modMask .|. shiftMask, xK_Return),
     spawn $ XMonad.terminal conf)

  , ((modMask, xK_p),
     spawn "~/.xmonad/bin/dmenu")

  -- Close focused window.
  , ((modMask .|. shiftMask, xK_c),
     kill)

  -- Cycle through the available layout algorithms.
  , ((modMask, xK_space),
     sendMessage NextLayout)

  --  Reset the layouts on the current workspace to default.
  , ((modMask .|. shiftMask, xK_space),
     setLayout $ XMonad.layoutHook conf)

  -- Resize viewed windows to the correct size.
  , ((modMask, xK_n),
     refresh)

  -- Move focus to the next window.
  , ((modMask, xK_Tab),
     windows W.focusDown)

  -- Move focus to the next window.
  , ((modMask, xK_j),
     windows W.focusDown)

  -- Move focus to the previous window.
  , ((modMask, xK_k),
     windows W.focusUp  )

  -- Move focus to the master window.
  , ((modMask, xK_m),
     windows W.focusMaster  )

  -- Swap the focused window and the master window.
  , ((modMask, xK_Return),
     windows W.swapMaster)

  -- Swap the focused window with the next window.
  , ((modMask .|. shiftMask, xK_j),
     windows W.swapDown  )

  -- Swap the focused window with the previous window.
  , ((modMask .|. shiftMask, xK_k),
     windows W.swapUp    )

  -- Shrink the master area.
  , ((modMask, xK_h),
     sendMessage Shrink)

  -- Expand the master area.
  , ((modMask, xK_l),
     sendMessage Expand)

  -- Push window back into tiling.
  , ((modMask, xK_t),
     withFocused $ windows . W.sink)

  -- Increment the number of windows in the master area.
  , ((modMask, xK_comma),
     sendMessage (IncMasterN 1))

  -- Decrement the number of windows in the master area.
  , ((modMask, xK_period),
     sendMessage (IncMasterN (-1)))

  -- Toggle the status bar gap.
  -- TODO: update this binding with avoidStruts, ((modMask, xK_b),

  -- Quit xmonad.
  --, ((modMask .|. shiftMask, xK_q),
    -- spawn "gnome-session-quit --logout --no-prompt")
     --promptio (exitWith ExitSuccess))
  -- Quit xmonad
      , ((modMask .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

  -- Restart xmonad.
  , ((modMask, xK_q),
     restart "xmonad" True)
  ]
  ++

  -- mod-[1..9], Switch to workspace N
  -- mod-shift-[1..9], Move client to workspace N
  [((m .|. modMask, k), windows $ f i)
      | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
      , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
  ++

  -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
  -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
  [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
      | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
      , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

main :: IO ()
main = do
    dbus <- D.connectSession
    getWellKnownName dbus
    xmonad $ gnomeConfig
         { logHook    = dynamicLogWithPP (prettyPrinter dbus)
         , modMask    = myModMask
         , keys       = myKeys
         , workspaces = myWorkspaces
         , manageHook = manageHook gnomeConfig <+> composeAll myManageHook
         }

prettyPrinter :: D.Client -> PP
prettyPrinter dbus = defaultPP
    { ppOutput   = dbusOutput dbus
    , ppTitle    = pangoSanitize
    , ppCurrent  = pangoColor "green" . wrap "[" "]" . pangoSanitize
    , ppVisible  = pangoColor "yellow" . wrap "(" ")" . pangoSanitize
    , ppHidden   = const ""
    , ppUrgent   = pangoColor "red"
    , ppLayout   = const ""
    , ppSep      = " "
    }

getWellKnownName :: D.Client -> IO ()
getWellKnownName dbus = do
  D.requestName dbus (D.busName_ "org.xmonad.Log")
                [D.AllowReplacement, D.ReplaceExisting, D.DoNotQueue]
  return ()

dbusOutput :: D.Client -> String -> IO ()
dbusOutput dbus str = D.emit dbus
                             "/org/xmonad/Log"
                             "org.xmonad.Log"
                             "Update"
                             [D.toVariant ("<b>" ++ (UTF8.decodeString str) ++ "</b>")]

pangoColor :: String -> String -> String
pangoColor fg = wrap left right
  where
    left  = "<span foreground=\"" ++ fg ++ "\">"
    right = "</span>"

pangoSanitize :: String -> String
pangoSanitize = foldr sanitize ""
  where
    sanitize '>'  xs = "&gt;" ++ xs
    sanitize '<'  xs = "&lt;" ++ xs
    sanitize '\"' xs = "&quot;" ++ xs
    sanitize '&'  xs = "&amp;" ++ xs
    sanitize x    xs = x:xs
