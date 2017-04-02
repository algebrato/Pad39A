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

import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.SetWMName
import XMonad.Hooks.DynamicLog

import qualified Data.Map as M 

myConf = gnomeConfig

altMask = mod1Mask
winMask = mod4Mask
myMask  = altMask

myKeys conf = M.fromList $  
			  [
				((myMask, xK_F5), spawn $ XMonad.terminal conf ),
				((myMask, xK_F5), spawn "xterm"),
				((myMask, xK_F2), spawn "dmenu_run"),
				((myMask, xK_F8), spawn "xbacklight -dec 10"),
				((myMask, xK_F9), spawn "xbacklight -inc 10"),
				((controlMask .|. shiftMask, xK_F12), io (exitWith ExitSuccess) ),
				((myMask .|. controlMask, xK_Left),  prevWS),
				((myMask .|. controlMask, xK_Right), nextWS)
			  ]


myTab = named "tab" $ avoidStruts $ noBorders simpleTabbed 
myLayout = myTab


main = 
	do
	xmproc <- spawnPipe "xmobar"
	xmonad $ myConf 
				{
					  logHook = dynamicLogWithPP xmobarPP
							  {
								 ppOutput = hPutStrLn xmproc 
							   , ppLayout = const "" 
							   , ppTitle  = xmobarColor "green" "" . shorten 80 	
							  }
							  >> ewmhDesktopsLogHook
						 	  >> setWMName "LG3D"
					, keys       = myKeys  
					, layoutHook = myLayout
				}


  
