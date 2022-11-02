"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sections:
"    -> General
"    -> VIM user interface
"    -> Colors
"    -> Files and backups
"    -> Text, tab and indent related
"    -> Moving around, tabs, windows and buffers
"    -> Status line
"    -> Key mappings
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" -> General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible

" Sets how many lines of history VIM has to remember
set history=500

" Enable filetype detection
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread
au FocusGained,BufEnter * checktime

" With a map leader it's possible to do extra key combinations
let mapleader = "\<space>"

" Paste copied text from the external program with just p
" NOTE: vim --version should have the +clipboard or +xterm_clipboard flags
set clipboard=unnamed,unnamedplus

" Prevent vim from clearing the clipboard on exit
autocmd VimLeave * call system("xsel -ib", getreg('+'))

set updatetime=100

" Automatic undo persistence
set undodir=~/.vim/undo_dir
set undofile

" Enable the use of the mouse
set mouse=a

" Set the default file encoding to UTF-8:
set encoding=utf-8

" Use Unix as the standard file type
set fileformats=unix,dos,mac

" Spell-check Markdown files and Git Commit Messages
autocmd FileType markdown setlocal spell
autocmd FileType gitcommit setlocal spell

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" -> VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Avoid garbled characters in Chinese language windows OS
let $LANG='en'
set langmenu=en

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

"Always show current position
set ruler

" Height of the command bar
set cmdheight=1

" A buffer becomes hidden when it is abandoned
set hidden

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch

" How many tenths of a second to blink when matching brackets
set mat=2

" highlight at the 80th column
highlight ColorColumn ctermbg=235 guibg=#2c2d27
let &colorcolumn="120,".join(range(120,999),",")

" Enable line number and relative line number
set number
set relativenumber number

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" -> Colors
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable

" Use 24-bits color
" ref: https://github.com/vim/vim/issues/993#issuecomment-255651605
let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
set termguicolors

" 3rd party color scheme
try
    colorscheme codedark
catch
endtry


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" -> Files and backups
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git etc. anyway...
set nobackup
set nowb
set noswapfile


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" -> Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Lines longer than the width of the window will not wrap and only part of long lines will be displayed
set nowrap

" Use spaces instead of tabs
set expandtab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" indent
set autoindent
set smartindent
set cindent

" show tab and space
set listchars=tab:→\ ,space:·
set list


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" -> Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Return to last edit position when opening files
" au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Return to last edit position when opening files, unless this is a git commit
au BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") && &filetype != "gitcommit" |
        \ execute("normal `\"") |
    \ endif

" Automatically removing all trailing whitespace
au BufWritePre * :%s/\s\+$//e


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" -> Status line
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" -> Key mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Fast saving
nmap <leader>w :w!<cr>

" Tab navigation
nnoremap <C-Up> gT
nnoremap <C-Down> gt

" Disable search highlight
nnoremap <esc><esc> :noh<return><esc>

" Create an undo breakpoint when deleting chunks in insert mode
" with Ctrl-W (delete the word before the cursor) and Ctrl-U (delete all text before the cursor)
inoremap <c-w> <c-g>u<c-w>
inoremap <c-u> <c-g>u<c-u>

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

" :W sudo saves the file
" (useful for handling the permission-denied error)
command! W execute 'w !sudo -v && sudo tee % > /dev/null' <bar> edit!

" Let shift+arrows and ctrl+arrows work in Vim in tmux.
" ref: https://superuser.com/a/402084
if &term =~ '^\%(screen\|tmux\)'
    " tmux will send xterm-style keys when its xterm-keys option is on
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
endif
