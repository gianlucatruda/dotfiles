set nocompatible              " be iMproved, required

" Enable syntax highlighting
syntax on

" Change cursor shape in different modes
"  1 -> blinking block
"  2 -> solid block 
"  3 -> blinking underscore
"  4 -> solid underscore
"  5 -> blinking vertical bar
"  6 -> solid vertical bar
let &t_SI.="\e[5 q" "SI = INSERT mode
let &t_SR.="\e[4 q" "SR = REPLACE mode
let &t_EI.="\e[1 q" "EI = NORMAL mode (ELSE)

" Python-specific tweaks suggested by https://docs.python-guide.org/dev/env/#text-editors
set textwidth=79  " lines longer than 79 columns will be broken
set shiftwidth=4  " operation >> indents 4 columns; << unindents 4 columns
set tabstop=4     " a hard TAB displays as 4 columns
set expandtab     " insert spaces when hitting TABs
set softtabstop=4 " insert/delete 4 spaces when hitting a TAB/BACKSPACE
set shiftround    " round indent to multiple of 'shiftwidth'
set autoindent    " align the new line indent with the previous line

" Custom colour scheme : http://vimdoc.sourceforge.net/htmldoc/syntax.html#{group-name}
" highlight Normal ctermfg=White
highlight Comment ctermfg=DarkGray
highlight Constant ctermfg=DarkGray
highlight Identifier ctermfg=Green
highlight Statement ctermfg=DarkBlue
highlight PreProc ctermfg=DarkBlue
highlight Type ctermfg=DarkRed
highlight Special ctermfg=DarkMagenta
highlight LineNr ctermfg=DarkGray

" Make Vim more useful
filetype on
set nocompatible
" Enhance command-line completion
set wildmenu
" Allow cursor keys in insert mode
set esckeys
" Allow backspace in insert mode
set backspace=indent,eol,start
" Optimize for fast terminal connections
set ttyfast
" Centralize backups, swapfiles and undo history
set backupdir=~/.vim/backups
set directory=~/.vim/swaps
if exists("&undodir")
	set undodir=~/.vim/undo
endif

" Don’t create backups when editing files in certain directories
set backupskip=/tmp/*,/private/tmp/*
" Indent using 4 spaces
set tabstop=4
set expandtab
" Enable line numbers
set number
" Highlight searches
set hlsearch
" Highlight dynamically as pattern is typed
set incsearch
" Always show status line
set laststatus=2
" Enable mouse in all modes
" set mouse=a
" Don’t reset cursor to start of line when moving around.
set nostartofline
" Show the cursor position
set ruler
" Don’t show the intro message when starting Vim
set shortmess=atI
" Show the current mode
set showmode
" Show the filename in the window titlebar
set title
" Show the (partial) command as it’s being typed
set showcmd
" Start scrolling three lines before the horizontal window border
set scrolloff=3
" Word and Line wrapping
set lbr "word wrap
set tw=500
set wrap "Wrap lines

" Automatic commands
if has("autocmd")
	" Enable file type detection
	filetype on
	" Treat .md files as Markdown
	autocmd BufNewFile,BufRead *.md setlocal filetype=markdown
endif
