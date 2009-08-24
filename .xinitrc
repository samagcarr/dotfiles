#!/bin/bash

eval `dbus-launch --sh-syntax --exit-with-session`
xbindkeys &
xsetroot -cursor_name left_ptr -solid "#B1DAFC" &
trayer --edge top --align right --widthtype pixel --width 200 --height 1 --SetDockType true --SetPartialStrut true --expand true --alpha 100 --tint 0x0099ff --transparent true &

exec xmonad
