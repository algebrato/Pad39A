import System.IO
import System.Exit

import XMonad
import XMonad.Config.Gnome
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.CustomKeys
import XMonad.Util.Font

import XMonad.Actions.CycleWS
import XMonad.Layout.Tabbed
import XMonad.Layout.Named
import XMonad.Layout.NoBorders
import XMonad.Layout.WindowNavigation
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Fullscreen
import XMonad.Layout.SubLayouts

import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.SetWMName
import XMonad.Hooks.DynamicLog

import qualified Data.Map as M 

myConf = gnomeConfig


-- CONFIGURAZIONE TASTI; GLOBAL ENV; SETTARE myMask COME CI SI TROVA MEGLIO --
altMask = mod1Mask
winMask = mod4Mask
myMask  = altMask
myNB  = "#FDFDC3"
myFC  = "#3398CE"




-- CONFIGURAZIONE CARINA DEI WORKSPACES: CON NOME F:n --
myWorkspaces = (miscs 8) ++ ["fullscreen", "im"]
	where miscs = map (("F" ++) . show) . (flip take) [1..] 
isFullscreen = (== "fullscreen")


-- KEYBINDING IN FUNZIONE A myMask --
myKeys conf = M.fromList $[
	((myMask, xK_F5), spawn $ XMonad.terminal conf ),
	((myMask, xK_F5), spawn "xterm"),
	((myMask, xK_F2), spawn "dmenu_run -fn -misc-fixed-*-r-*-*-15-*-*-*-*-*-*-* "),
	((myMask, xK_F8), spawn "xbacklight -dec 10"),
	((myMask, xK_F9), spawn "xbacklight -inc 10"),
	((myMask .|. controlMask, xK_r), spawn "xmonad --restart"), --Utile quando si è un modalità di debug --
	((controlMask .|. shiftMask, xK_F12), io (exitWith ExitSuccess) ),
	((myMask .|. controlMask, xK_Left),  prevWS),
	((myMask .|. controlMask, xK_Right), nextWS)
	]


-- CONFIGURAZIONE DEL LAYOUT --

myLayout = windowNavigation $ normal 
	where    normal = tallLayout
		      ||| wideLayout
		      ||| tabbedLayout

tallLayout   = named "tall" $ avoidStruts $ subTabbed $ basicLayout
wideLayout   = named "wide" $ avoidStruts $ subTabbed $ Mirror basicLayout
tabbedLayout = named "tab"  $ avoidStruts $ noBorders simpleTabbed

basicLayout = Tall nmaster delta ratio where
    nmaster = 1
    delta   = 3/100
    ratio   = 1/2



-- MAIN --

main = 
	do
	xmproc <- spawnPipe "xmobar"
	xmonad $ myConf {
	  logHook = dynamicLogWithPP xmobarPP{
 	    ppOutput = hPutStrLn xmproc 
	    , ppLayout = const "" 
	    , ppTitle  = xmobarColor "green" "" . shorten 80
	  }
	  >> ewmhDesktopsLogHook
	  >> setWMName "LG3D"
	  , keys       = myKeys
	  , layoutHook = myLayout
	  , workspaces = myWorkspaces
	  , normalBorderColor = myNB
	  , focusedBorderColor = myFC
	}


  
