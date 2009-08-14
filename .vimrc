set nocompatible

syntax on
set hlsearch  " highlight search
set incsearch  " incremental search, search as you type
set ignorecase " Ignore case when searching 
set smartcase " Ignore case when searching lowercase
set background=dark
set nowrap
set linebreak  " Wrap at word

set tabstop=4
set shiftwidth=4
set autoindent
set smarttab

if $TERM =~ "-256color"
	set t_Co=256
	colorscheme ir_black
endif

autocmd BufRead /tmp/mutt-pH-*   :source ~/.vim/mailrc
