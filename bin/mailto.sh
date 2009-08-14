#!/bin/bash
MAILTO_URL="$1" 

#Strip off the protocol
MAIL_DATA=$(echo "$MAILTO_URL" | /bin/sed -s 's/^[Mm][Aa][Ii][Ll][Tt][Oo]://') 

#Get Recipient and strip it off
RECIPIENT=$(echo "$MAIL_DATA" | cut -d? -f1 -)
MAIL_DATA=$(echo "$MAIL_DATA" | /bin/sed -s s/^$RECIPIENT//) 

#Get Subject,BCC, and CC
SUBJECT=$(echo "$MAIL_DATA" | \
/bin/sed -s 's/.*?[Ss][Uu][Bb][Jj][Ee][Cc][Tt]=//' | /bin/sed -s 's/?.*//')
BCC=$(echo "$MAIL_DATA" | /bin/sed -s 's/.*?[Bb][Cc][Cc]=//' | \
/bin/sed -s 's/?.*//')
CC=$(echo "$MAIL_DATA" | /bin/sed -s 's/.*?[Cc][Cc]=//' | \
/bin/sed -s 's/?.*//') 

#Call mutt in an aterm
urxvt -e mutt "$RECIPIENT" -b "$BCC" -c "$CC" -s "$SUBJECT"
