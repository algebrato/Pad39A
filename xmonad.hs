{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TypeSynonymInstances, FlexibleContexts, NoMonomorphismRestriction #-}


import System.IO
import System.Exit

import XMonad
import XMonad.Config.Gnome
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.CustomKeys
import XMonad.Util.Font
import XMonad.Util.WindowProperties

import XMonad.Actions.CycleWS
import XMonad.Actions.GridSelect

import XMonad.Layout.Tabbed
import XMonad.Layout.Named
import XMonad.Layout.NoBorders
import XMonad.Layout.WindowNavigation
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Fullscreen
import XMonad.Layout.SubLayouts
import XMonad.Layout.Reflect
import XMonad.Layout.LayoutModifier
import XMonad.Layout.Grid


import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.SetWMName
import XMonad.Hooks.DynamicLog

import qualified Data.Map as M 
import qualified XMonad.StackSet as S

myConf = gnomeConfig


-- CONFIGURAZIONE TASTI; GLOBAL ENV; SETTARE myMask COME CI SI TROVA MEGLIO --
altMask = mod1Mask
winMask = mod4Mask
myMask  = altMask
myNB  = "#0000FF"
myFC  = "#FF0000"




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
	((myMask, xK_l), spawn "xscreensaver-command -lock"),
	((controlMask .|. shiftMask, xK_F12), io (exitWith ExitSuccess) ),
	((myMask .|. controlMask, xK_Left),  prevWS),
	((myMask .|. controlMask, xK_Right), nextWS),
	((myMask, xK_space), sendMessage NextLayout),
	((myMask, xK_Tab), windows S.focusDown),
	((myMask .|. controlMask .|. shiftMask, xK_Left), shiftToPrev),
	((myMask .|. controlMask .|. shiftMask, xK_Right), shiftToNext),
	((winMask .|. altMask  , xK_k  )   , sendMessage Shrink),
	((winMask .|. altMask  , xK_l )    , sendMessage Expand),
	((myMask, xK_w), goToSelected defaultGSConfig)
	]


-- CONFIGURAZIONE DEL LAYOUT --

myLayout =  windowNavigation $ fullscreen $ normal  where
	normal = tallLayout ||| wideLayout ||| tabbedLayout
	fullscreen = onWorkspace "fullscreen" fullscreenLayout
	im = onWorkspace "im" imLayout


tallLayout   = named "tall" $ avoidStruts $ subTabbed $ basicLayout
wideLayout   = named "wide" $ avoidStruts $ subTabbed $ Mirror basicLayout
tabbedLayout = named "tab"  $ avoidStruts $ noBorders simpleTabbed
fullscreenLayout = named "fullscreen" $ noBorders Full

basicLayout = Tall nmaster delta ratio where
    nmaster = 1
    delta   = 3/100
    ratio   = 1/2


-- ROSTER PER IM-LAYOUT --

imLayout = avoidStruts $ reflectHoriz $ withIMs ratio rosters chatLayout where
	chatLayout 	= Grid
	ratio		= 1/6
	rosters		= [skypeRoster, pidginRoster]
	pidginRoster	= And (ClassName "Pidgin") (Role "buddy_list")
	skypeRoster	= (ClassName "Skype") `And` (Not (Title "Options")) `And` (Not (Role "Chats")) `And` (Not (Role "CallWindowForm"))


data AddRosters a = AddRosters Rational [Property] deriving (Read, Show)

--instance LayoutModifier AddRosters Window where
--	modifyLayout (AddRosters ratio props) = applyIMs ratio props
--	modifierDescription _                = "IMs"

withIMs :: LayoutClass l a => Rational -> [Property] -> l a -> ModifiedLayout AddRosters l a
withIMs ratio props = ModifiedLayout $ AddRosters ratio props
gridIMs :: Rational -> [Property] -> ModifiedLayout AddRosters Grid a
gridIMs ratio props = withIMs ratio props Grid
hasAnyProperty :: [Property] -> Window -> X Bool
hasAnyProperty [] _ = return False
hasAnyProperty (p:ps) w = do
    b <- hasProperty p w
    if b then return True else hasAnyProperty ps w
--applyIMs :: (LayoutClass a b) => Rational
	
--applyIMs :: (LayoutClass l Window) =>
--               Rational
--            -> [Property]
--            -> S.Workspace WorkspaceId (l Window) Window
--            -> Rectangle
--            -> X ([(Window, Rectangle)], Maybe (l Window))
--applyIMs ratio props wksp rect = do
    --let stack = S.stack wksp
    --let ws = S.integrate' $ stack
    --rosters <- filterM (hasAnyProperty props) ws
    --let n = fromIntegral $ length rosters
    --let (rostersRect, chatsRect) = splitHorizontallyBy (n * ratio) rect
    --let rosterRects = splitHorizontally n rostersRect
    --let filteredStack = stack >>= S.filter (`notElem` rosters)
    --(a,b) <- runLayout (wksp {S.stack = filteredStack}) chatsRect
    --return (zip rosters rosterRects ++ a, b)


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


  
