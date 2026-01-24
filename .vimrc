" vi-Mproved, required
set nocompatible              

" Set dark background
set background=dark  " or light

" Manually set colorscheme (my favourites)
" colorscheme habamax
" colorscheme default
" colorscheme darkblue
" colorscheme desert
" colorscheme slate

" Enable syntax highlighting
syntax on

" Use system clipboard as default 
set clipboard=unnamed

set autoindent    " align the new line indent with the previous line

" Always show status line
set laststatus=2
" Format the status line
set statusline=
set statusline+=\ %{mode()}\ 
set statusline+=%#LineNr#
set statusline+=\ %{fnamemodify(getcwd(),':t')}/ 
set statusline+=\%f
set statusline+=%m
set statusline+=%=
set statusline+=%#CursorColumn#
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]
"set statusline+=\ %p%%
set statusline+=\ %l:%c

filetype on           " Enable filetype detection
filetype indent on    " Enable filetype-specific indenting
filetype plugin on    " Enable filetype-specific plugins

" Set to auto read when a file is changed from the outside
set autoread
au FocusGained,BufEnter,CursorHold,CursorHoldI * checktime
set updatetime=1000
" Ignore case when searching
set ignorecase
" Enhance command-line completion
set wildmenu
" Allow cursor keys in insert mode
set esckeys
" Allow backspace in insert mode
set backspace=indent,eol,start
" Optimize for fast terminal connections
set ttyfast
" Enable line numbers
set number
" Enable relative line numbers
" set relativenumber
" Highlight searches
set hlsearch
" Highlight dynamically as pattern is typed
set incsearch
" Enable mouse in all modes
set mouse=a
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
set titlelen=25
set titlestring=%F
" Show the (partial) command as it’s being typed
set showcmd
" Start scrolling three lines before the horizontal window border
set scrolloff=3

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

" Word and Line wrapping
set lbr "word wrap
set wrap "Wrap lines

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" => Turn persistent undo on
"    means that you can undo even when you close a buffer/VIM
try
    set undodir=~/.vim_runtime/temp_dirs/undodir
    set undofile
catch
endtry

"Restore cursor to file position in previous editing session
set viminfo='10,\"100,:20,%,n~/.viminfo
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif

" Automatic commands
if has("autocmd")
	" Enable file type detection
	filetype on
	" Treat .md files as Markdown
	autocmd BufNewFile,BufRead *.md setlocal filetype=markdown
endif

" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction

" Python-specific tweaks suggested by https://docs.python-guide.org/dev/env/#text-editors
" set textwidth=79  " lines longer than 79 columns will be broken
" set shiftwidth=4  " operation >> indents 4 columns; << unindents 4 columns
" set tabstop=4     " a hard TAB displays as 4 columns
" set expandtab     " insert spaces when hitting TABs
" set smarttab      " Be smart when using tabs ;)
" set softtabstop=4 " insert/delete 4 spaces when hitting a TAB/BACKSPACE
" set shiftround    " round indent to multiple of 'shiftwidth'

" Ensure filetypes are properly recognised
" autocmd BufNewFile,BufRead *.js setfiletype javascript
" autocmd BufNewFile,BufRead *.jsx setfiletype javascript.jsx
" autocmd BufNewFile,BufRead *.ts setfiletype typescript
" autocmd BufNewFile,BufRead *.tsx setfiletype typescript.tsx

" Verical ruler / column to track line width
"set colorcolumn=80
"highlight ColorColumn ctermbg=darkgrey guibg=darkgrey

" Override some settings when using specific filetypes
" autocmd FileType javascript,javascript.jsx,javascriptreact,typescript,typscript.tsx,typescriptreact,json setlocal shiftwidth=2 tabstop=2 expandtab smarttab softtabstop=2

" Centralize backups, swapfiles and undo history
" set backupdir=~/.vim/backups
" set directory=~/.vim/swaps
" if exists("&undodir")
" 	set undodir=~/.vim/undo
" endif

" Don’t create backups when editing files in certain directories
" set backupskip=/tmp/*,/private/tmp/*

" Enable spellchecking for Markdown and text files
" setglobal spell spelllang=en_gb
" autocmd FileType markdown setlocal spell spelllang=en_gb
" autocmd FileType text setlocal spell spelllang=en_gb

" Enable automatic line breaks (textwrapping) ONLY on markdown and text files
" setglobal textwidth=0
" autocmd FileType markdown setlocal textwidth=90
" autocmd FileType text setlocal textwidth=90
