import XMonad

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.Place

import XMonad.Layout.NoBorders
import XMonad.Layout.LayoutHints
import XMonad.Layout.PerWorkspace
import XMonad.Layout.ResizableTile
import XMonad.Layout.IM
import XMonad.Layout.Reflect
import XMonad.Layout.Named

import XMonad.Util.Run
import XMonad.Util.EZConfig (additionalKeys, additionalKeysP)
import XMonad.Util.Loggers

import Data.Ratio ((%))
import Graphics.X11
import System.Exit
import System.IO

import qualified XMonad.StackSet as W
 
main = do
	h <- spawnPipe statusBar'
	xmonad $ withUrgencyHook NoUrgencyHook $ defaultConfig
		{ modMask = mod4Mask
		, terminal = "urxvt"
		, normalBorderColor = "#A9A9A9"
		, focusedBorderColor = "#74DE73"
		, workspaces = [ "term", "web", "chat", "other", "5", "6", "7", "8", "9" ]
		, logHook = dynamicLogWithPP (prettyPrint h)
		, layoutHook = layoutHook'
		, manageHook = manageDocks <+> placeHook simpleSmart <+> manageHook' }
		`additionalKeysP`
		[ ("M-p", spawn dmenuCmd)
		, ("M-x f", spawn "firefox")
		, ("M-x n", spawn "nautilus --no-desktop")
		, ("M-x u", spawn "urxvt")
		, ("M-x e", spawn "easytag")
		, ("M-x p", spawn "pidgin")
		, ("M-x b", spawn "nitrogen ~/pics/Backgrounds")
		, ("M-x l", spawn "lxappearance")
		, ("M-x c", spawn "gcolor2")
		, ("M-w", placeFocused simpleSmart) ]


layoutHook' = avoidStruts $ layoutHints $ onWorkspace "chat" chat2
			$ smartBorders (resizableTile ||| Mirror resizableTile ||| Full)
				where
					resizableTile = ResizableTall nmaster delta ratio []
					nmaster = 1
					ratio = toRational (2/(1+sqrt(5)::Double))
					delta = 3/100
					chat = noBorders $ withIM (1%8) (Role "buddy_list") $ reflectHoriz $ withIM (3%8) (ClassName "Gwibber") resizableTile
					chat2 = named "IM" chat

statusBar' = "dzen2 -x '0' -y '0' -h '16' -w 1400 -ta l -fg '#777777' -bg '#000000' -fn 'MonteCarlo-10'"
dmenuCmd = "dmenu_run -nb '#000' -nf '#777' -p '»' -sb '#000' -sf '#fff' -w 150 -l 25 -c -xs -rs -ni -x 1 -y 17"

prettyPrint h = defaultPP
	{ ppCurrent = wrap "^fg(#ffffff)" "^fg()^p()"
	, ppHidden = wrap "" ""
	, ppHiddenNoWindows = const ""
	, ppUrgent = wrap "^fg(#1994d1)" "^fg()^p()"
	, ppSep = " "
	, ppWsSep = " "
	, ppExtras = [ maildirUnread "~/mail/in", maildirNew "~/mail/in" ]
	, ppTitle = dzenColor "#ffffff" ""
	, ppLayout = dzenColor ("#1994d1") "" .
		(\x -> case x of
		"Hinted Full" -> "[]"
		"Hinted ResizableTall" -> "|="
		"Hinted Mirror ResizableTall" -> "TT"
		"Hinted IM" -> "IM"
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
		myOtherFloats = [ "Downloads", "Firefox Preferences", "Save As...", "Send file", "Open", "File Transfers" ]
		myIM = [ "Pidgin", "Gwibber" ]
		myBrowse = [ "Firefox" ]
