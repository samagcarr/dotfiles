#!/bin/bash
[ -z "$PS1" ] && return

PATH="~/bin:$PATH"

shopt -s cdspell
shopt -s dotglob
shopt -s extglob
shopt -s histappend
shopt -s checkwinsize

export EDITOR="vim"
export BROWSER="firefox"
export OOO_FORCE_DESKTOP=gnome

eval `dircolors -b ~/.dir_colors`


alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias pacman='pacman-color'
alias slurpy='slurpy -c'

PS1='\[\e[1;36m\]\w \[\e[0m\]'

export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;34m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

if [ "$TERM" = "linux" ]; then
    echo -en "\e]P0000000" #black
    echo -en "\e]P8555753" #darkgrey
    echo -en "\e]P1ff6565" #darkred
    echo -en "\e]P9ff8d8d" #red
    echo -en "\e]P293d44f" #darkgreen
    echo -en "\e]PAc8e7a8" #green
    echo -en "\e]P3eab93d" #brown
    echo -en "\e]PBffc123" #yellow
    echo -en "\e]P4204a87" #darkblue
    echo -en "\e]PC3465a4" #blue
    echo -en "\e]P5ce5c00" #darkmagenta
    echo -en "\e]PDf57900" #magenta
    echo -en "\e]P689b6e2" #darkcyan
    echo -en "\e]PE46a4ff" #cyan
    echo -en "\e]P7cccccc" #lightgrey
    echo -en "\e]PFffffff" #white
    clear # bring us back to default input colours
fi

ircread() { 
  tail -f /home/scarr/irc/irc.$1.net/\#$2/out | ircc
}

ircput() { 
  echo $3 > /home/scarr/irc/irc.$1.net/\#$2/in
}

aurdownload() {
  wget "http://aur.archlinux.org/packages/$1/$1.tar.gz" -O - | tar xzf -
  cd $1
}
