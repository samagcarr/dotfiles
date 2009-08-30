import XMonad

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.ManageDocks

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
		, terminal = "urxvtc"
		, normalBorderColor = "#A9A9A9"
		, focusedBorderColor = "#74DE73"
		, workspaces = map show [1..9]
		, logHook = dynamicLogWithPP (prettyPrint h)
		, layoutHook = layoutHook'
		, manageHook = manageDocks <+> manageHook' }
		`additionalKeysP`
		[ ("M-p", spawn dmenuCmd)
		, ("M-x n", spawn "nautilus --no-desktop")
		, ("M-x b", spawn "nitrogen ~/pics/Backgrounds")
		, ("M-x c", spawn "gcolor2") ]


layoutHook' = avoidStruts $ layoutHints $ onWorkspace "3" chat2
			$ smartBorders (resizableTile ||| Mirror resizableTile ||| Full)
				where
					resizableTile = ResizableTall nmaster delta ratio []
					nmaster = 1
					ratio = toRational (2/(1+sqrt(5)::Double))
					delta = 3/100
					chat = noBorders $ withIM (1%8) (Role "contact_list") $ reflectHoriz $ withIM (3%8) (ClassName "Gwibber") resizableTile
					chat2 = named "IM" chat

statusBar' = "dzen2 -x '0' -y '0' -h '16' -w 1400 -ta l -fg '#777777' -bg '#000000' -fn 'MonteCarlo-10'"
dmenuCmd = "dmenu_run -nb '#000' -nf '#777' -p '»' -sb '#000' -sf '#fff' -w 250 -l 25 -c -xs -rs -ni -x 1 -y 17 -fn 'MonteCarlo:size=1-'"

prettyPrint h = defaultPP
	{ ppCurrent = dzenColor "#ffffff" "#71A2E7" . wrap " " " "
	, ppHidden = wrap " " " "
	, ppHiddenNoWindows = const ""
	, ppUrgent = dzenColor "#ffffff" "#003277" . dzenStrip
	, ppSep = " "
	, ppWsSep = ""
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
	, [className =? o	--> doF (W.shift "4") | o <- myOther]
	, [title     =? t	--> doFloat | t <- myOtherFloats]
	, [className =? i	--> doF (W.shift "3") | i <- myIM]
	, [className =? b	--> doF (W.shift "2") | b <- myBrowse] ]
	where
		myOther = [ "Gimp", "Nitrogen", "Gucharmap", "Transmission", "Lxappearance", "Osmo" ]
		myOtherFloats = [ "Downloads", "Firefox Preferences", "Save As...", "Send file", "Open", "File Transfers" ]
		myIM = [ "Pidgin", "Gwibber" ]
		myBrowse = [ "Firefox" ]
