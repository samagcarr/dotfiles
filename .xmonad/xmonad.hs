import XMonad

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.XPropManage

import XMonad.Layout.NoBorders
import XMonad.Layout.LayoutHints
import XMonad.Layout.PerWorkspace
import XMonad.Layout.ResizableTile
import XMonad.Layout.IM
import XMonad.Layout.Spacing

import XMonad.Util.Run
import XMonad.Util.EZConfig (additionalKeys, additionalKeysP)

import Data.Ratio ((%))
import Graphics.X11
import System.Exit
import System.IO
import Foreign.C.Types (CLong)

import qualified XMonad.StackSet as W
 
main = do
	h <- spawnPipe statusBar'
	xmonad $ withUrgencyHook NoUrgencyHook $ defaultConfig
		{ modMask = mod4Mask
		, terminal = "urxvt"
		, borderWidth = 4
		, normalBorderColor = "#4d4d4d"
		, focusedBorderColor = "#1994d1"
		, workspaces = [ "term", "irc", "web", "chat", "other", "6", "7", "8", "9" ]
		, logHook = dynamicLogWithPP (prettyPrint h)
		, layoutHook = layoutHook'
		, manageHook = manageHook' <+> manageDocks }
		`additionalKeysP`
		[ ("M-p", spawn "gmrun")
		, ("M-x f", spawn "firefox")
		, ("M-x n", spawn "nautilus --no-desktop")
		, ("M-x u", spawn "urxvt")
		, ("M-x a", spawn "abiword")
		, ("M-x e", spawn "easytag")
		, ("M-x p", spawn "pidgin")
		, ("M-x l", spawn "lxappearance")
		, ("M-x c", spawn "gcolor2")
		, ("M-x g", spawn "gucharmap") ]


layoutHook' = avoidStruts $ layoutHints $ onWorkspace "chat" chat
			$ smartBorders (resizableTile ||| Mirror resizableTile ||| Full)
				where
					resizableTile = ResizableTall nmaster delta ratio []
					nmaster = 1
					ratio = toRational (2/(1+sqrt(5)::Double))
					delta = 3/100
					chat = withIM (1%7) (Role "buddy_list") resizableTile

statusBar' = "dzen2 -x '0' -y '0' -h '16' -w 1600 -ta l -fg '#777777' -bg '#000000' -fn 'MonteCarlo-10'"

prettyPrint h = defaultPP
	{ ppCurrent = wrap "^fg(#ffffff)" "^fg()^p()" --Wrap
	, ppHidden = wrap "" ""
	, ppHiddenNoWindows = const ""
	, ppUrgent = wrap "^fg(#1994d1)" "^fg()^p()"
	, ppSep = " "
	, ppWsSep = " "
	, ppTitle = dzenColor "#ffffff" ""
	, ppLayout = dzenColor ("#1994d1") "" .
		(\x -> case x of
		"Hinted Full" -> "[]"
		"Hinted ResizableTall" -> "|="
		"Hinted Mirror ResizableTall" -> "TT"
		"Hinted IM ResizableTall" -> "IM"
		_ -> x )
	, ppOutput = hPutStrLn h }

manageHook' = composeAll .concat $
	[ [className =? f	--> doFloat | f <- myOther]
	, [className =? o	--> doF (W.shift "other") | o <- myOther]
	, [title     =? t	--> doFloat | t <- myOtherFloats]
	, [className =? i	--> doF (W.shift "chat") | i <- myIM]
	, [className =? b	--> doF (W.shift "web") | b <- myBrowse] ]
	where
		myOther = [ "Gimp", "Nitrogen", "Gucharmap", "Transmission", "Lxappearance", "Osmo" ]
		myOtherFloats = [ "Downloads", "Firefox Preferences", "Save As...", "Send file", "Open", "File Transfers"]
		myIM = [ "Pidgin" ]
		myBrowse = [ "Firefox" ]
