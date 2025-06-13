"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Maintainer:
"   Alowree XU
"   alowree@hotmail.com
" Start date:
"   Fri 2025-04-04 21:09:42 +0800
" Last updated:
"   Fri 2025-04-04 21:11:10 +0800
" Sections:
"    -> Plugins
"    -> General
"    -> VIM user interface
"    -> Colors and Fonts
"    -> Files and backups
"    -> Text, tab and indent related
"    -> Visual mode related
"    -> Moving around, tabs and buffers
"    -> Status line
"    -> Editing mappings
"    -> vimgrep searching and cope displaying
"    -> Spell checking
"    -> Misc
"    -> Helper functions
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins ---------------------------------------------- {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')
" Plug 'preservim/nerdtree'
Plug 'bullets-vim/bullets.vim'
Plug 'vim-airline/vim-airline'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neoclide/coc-prettier'
" Plug 'vim-scripts/fountain.vim'
Plug 'tpope/vim-markdown' | Plug 'ap/vim-css-color'
" Plug 'morhetz/gruvbox'
" Plug 'ashfinal/vim-colors-paper'
" Plug 'dunstontc/vim-vscode-theme'
" Plug 'tomasr/molokai'
" Plug 'jacoborus/tender.vim'
call plug#end()
" }}}

let mapleader = " "

" NERDTree Config
" nnoremap <leader>ee :NERDTreeToggle<CR>
" nnoremap <leader>ef :NERDTreeFind<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sets how many lines of history VIM has to remember
set history=500

" Turn on line numbers
set number

set relativenumber

set cursorline

" Enable mouse
set mouse=a

" Use vim, not vi api
set nocompatible

" Enable file type detection
filetype on

" Enable plugins and load plugin for the detected file type
filetype plugin on

" Load an indent file for the detected file type
filetype indent on

" Set to auto read when a file is changed from the outside
" Autoload files that have changed outside of vim
set autoread

au FocusGained,BufEnter * silent! checktime

" Use system clipboard
set clipboard+=unnamed

" Don't show intro
set shortmess+=I

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set 8 lines to the cursor - when moving vertically using j/k
set scrolloff=8

" Avoid garbled characters in Chinese language windows OS
let $LANG='en'
set langmenu=en
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

" Turn on the Wild menu
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

" Always show cursor - current position
set ruler

" Height of the command bar
set cmdheight=1

" A buffer becomes hidden
" A buffer is marked as ‘hidden’ if it has unsaved changes, and it is not currently loaded in a window
" if you try and quit Vim while there are hidden buffers, you will raise an error:
" E162: No write since last change for buffer “a.txt”
set hidden

set wrap

" Configure backspace so it acts as it should act
" Allow backspace to delete end of line, indent and start of line characters
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
" Incremental searching (search as you type)
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch

" Show incomplete commands
set showcmd

" Set built-in file system explorer to use layout similar to the NERDTree plugin
let g:netrw_liststyle=3

" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Properly disable sound on errors on MacVim
if has("gui_macvim")
    autocmd GUIEnter * set vb t_vb=
endif

" Add a bit extra margin to the left
set foldcolumn=1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable

" Set regular expression engine automatically
set regexpengine=0

" Without this setting, the color of GUI Vim will act strange
set t_Co=256

" Enable 256 colors palette in Gnome Terminal
if $COLORTERM == 'gnome-terminal'
    set t_Co=256
endif

" Third party color schemes installed at `~/.vim/colors/`
" No plugin required or installed
" Just saved as theme-file-name.vim into the folder

try
    colorscheme gruvbox
catch
endtry

set background=dark


" Set extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T
    set guioptions-=e
    set t_Co=256
    set guitablabel=%M\ %t
endif

" Set utf-8 as standard encoding and en_US as the standard language
set encoding=utf-8

" Use Unix as the standard file type
set ffs=unix,dos,mac


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git etc. anyway...
set nobackup

set nowritebackup

set noswapfile


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
" Convert tabs to spaces
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
" The number of spaces inserted for a tab (used for auto indenting)
set shiftwidth=4

" Set tab size in spaces (this is for manual indenting)
set tabstop=4

" Linebreak on 500 characters
set lbr
set tw=500

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines


""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

" Set cursor styles in Normal, Insert, and Command modes
augroup cursor_behaviour
    autocmd!

    " reset cursor on start:
    autocmd VimEnter * silent !echo -ne "\e[2 q"
    " cursor blinking bar on insert mode
    let &t_SI = "\e[5 q"
    " cursor steady block on command mode
    let &t_EI = "\e[2 q"

augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Fast saving
nmap <leader>ww :w<cr>
nmap <leader>qq :wq<cr>
nmap <leader>v :edit $MYVIMRC<cr>
nmap <leader>so :source ~/.vimrc<CR>
nmap <leader>wk :e ~/Documents/Weekly.md<cr>

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

" Smart way to move between windows
" <C-w>w toggles through the active windows
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-h> <C-w>h
map <C-l> <C-w>l

" Close the current buffer
map <leader>bd :Bclose<cr>:tabclose<cr>gT

" Close all the buffers
map <leader>ba :bufdo bd<cr>

map <leader>l :bnext<cr>
map <leader>h :bprevious<cr>

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove
map <leader>t<leader> :tabnext<cr>

" Let 'tl' toggle between this and the last accessed tab
let g:lasttab = 1
nmap <leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()


" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <C-r>=escape(expand("%:p:h"), " ")<cr>/

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Insert Date and Time
" inline style 2025-03-29 18:41:29; Sat 2025-03-29 18:42:36 +0800
iabbrev <expr> dt() strftime("%a %Y-%m-%d %H:%M:%S %z")

iabbrev >> →
iabbrev << ←
iabbrev ^^ ↑
iabbrev VV ↓
iabbrev 【【 「
iabbrev 】】 」
iabbrev 《《 『
iabbrev	》》 』

iabbrev btw By the way,
iabbrev fyi For your information ——
iabbrev asap as soon as possible.
iabbrev fedex FedEx
iabbrev dhl DHL
iabbrev ndl Nolan Digital Limited
iabbrev tcl Twine Company Limited

" Insert before the current character
" Sat Mar 29 18:35:28 2025
nnoremap <F5> "=strftime('%c')<CR>P

" inoremap <F5> <C-R>=strftime('%c')<CR>

" Sat 2025-03-29 18:40:41 +0800
inoremap <F5> <C-R>=strftime('%a %Y-%m-%d %H:%M:%S %z')<CR>

" new line style
" Mon, Mar 24, 2025 10:25:34 AM
nnoremap <leader>dt :r !date<CR>

" Why this is not working?
" nnoremap <leader>dt "=strftime('%a %Y-%m-%d %H:%M:%S %z')<CR>

""""""""""""""""""""""""""""""
" STATUS LINE ------------------------------------------------------------ {{{
" Purely manual, withouth plugins such as vim-airline
" Will be overwritten after you install vim-airline
""""""""""""""""""""""""""""""
" Don't show the mode, since it's already in the status line
set noshowmode

" Always show the status line
set laststatus=2

" Customize the status line
" https://jdhao.github.io/2019/11/03/vim_custom_statusline/
" function! Buf_total_num()
"     return len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))
" endfunction
"
" function! File_size(f)
"     let l:size = getfsize(expand(a:f))
"     if l:size == 0 || l:size == -1 || l:size == -2
"         return ''
"     endif
"     if l:size < 1024
"         return l:size.' bytes'
"     elseif l:size < 1024*1024
"         return printf('%.1f', l:size/1024.0).'k'
"     elseif l:size < 1024*1024*1024
"         return printf('%.1f', l:size/1024.0/1024.0/1024.0) . 'g'
"     endif
" endfunction
"
" " Define highlight groups for each mode
" hi ModeNormal cterm=bold ctermfg=232 ctermbg=30
" hi ModeInsert cterm=bold ctermfg=232 ctermbg=13
" hi ModeVisual cterm=bold ctermfg=232 ctermbg=11
"
" let g:currentmode={
"        \ 'n'  : 'NORMAL ',
"        \ 'v'  : 'VISUAL ',
"        \ 'V'  : 'V-Line ',
"        \ "\<C-V>" : 'V-Block ',
"        \ 'i'  : 'INSERT ',
"        \ 'R'  : 'R ',
"        \ 'Rv' : 'V-Replace ',
"        \ 'c'  : 'Command ',
"        \ }
"
" set statusline=
" " Show current mode
" " set statusline+=%5*\ %-10{toupper(g:currentmode[mode()])}
" set statusline+=%#ModeNormal#\ %-8{toupper(g:currentmode[mode()])}
" " Show current buffer number
" set statusline+=%<%1*[B-%n]%*
" set statusline+=%2*[TOTAL:%{Buf_total_num()}]%*
" " Show full file path, test change
" set statusline+=%3*\ %F\ %*
" set statusline+=%4*\ %{File_size(@%)}\ %*
" set statusline+=%5*\ [%{wordcount().words}]
" set statusline+=%6*\ %m%r%y\ %*
" set statusline+=%=%7*\ %{&ff}\ \|\ %{\"\".(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\",B\":\"\").\"\ \|\"}\ %-14.(%l:%c%V%)%*
" set statusline+=%8*\ %P\ %*
" " default bg for statusline is 236 in space-vim-dark
" hi User1 cterm=bold ctermfg=232 ctermbg=179
" hi User2 cterm=None ctermfg=214 ctermbg=242
" hi User3 cterm=bold ctermfg=169 ctermbg=239
" hi User4 cterm=None ctermfg=251 ctermbg=240
" hi User5 cterm=bold ctermfg=208 ctermbg=238
" hi User6 cterm=None ctermfg=246 ctermbg=237
" hi User7 cterm=None ctermfg=250 ctermbg=238
" hi User8 cterm=None ctermfg=249 ctermbg=240



" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" inoremap jk <Esc>

" Alt+j sends ^[j
" So need some tweaks for mapping Alt
" for i in range(97,122)
"   let c = nr2char(i)
"   exec "map \e".c." <M-".c.">"
"   exec "map! \e".c." <M-".c.">"
" endfor
"
"
" " Move a line down/up using Alt+[jk]
" nnoremap <A-j> :m .+1<CR>==
" nnoremap <A-k> :m .-2<CR>==
" inoremap <A-j> <Esc>:m .+1<CR>==gi
" inoremap <A-k> <Esc>:m .-2<CR>==gi
" vnoremap <A-j> :m '>+1<CR>gv=gv
" vnoremap <A-k> :m '<-2<CR>gv=gv





""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set nospell spelllang=en_us,cjk
" Pressing <Space>ss will toggle spell/nospecll checking
map <leader>ss :setlocal spell!<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remove the Windows ^M - when the encodings gets messed up
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Quickly open a markdown buffer for scribble
map <leader>x :e ~/buffer.md<cr>

" Toggle paste mode on and off
map <leader>pp :setlocal paste!<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions                                       {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction

function! CmdLine(str)
    call feedkeys(":" . a:str)
endfunction

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" Strip trailing white spaces on save
fun! StripTrailingWhitespace()
   " don't strip on these filetypes
   if &ft =~ 'markdown'
     return
   endif
   %s/\s\+$//e
 endfun
 autocmd BufWritePre * call StripTrailingWhitespace()

" Delete trailing white space on save, useful for some filetypes ;)
fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun

if has("autocmd")
    autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee :call CleanExtraSpaces()
endif

" Close all folds when opening a new buffer
 autocmd BufRead * setlocal foldmethod=marker
 autocmd BufRead * normal zM

" Rainbow parenthesis always on!
 if exists(':RainbowParenthesesToggle')
   autocmd VimEnter * RainbowParenthesesToggle
   autocmd Syntax * RainbowParenthesesLoadRound
   autocmd Syntax * RainbowParenthesesLoadSquare
   autocmd Syntax * RainbowParenthesesLoadBraces
 endif

" Markdown boilerplate for VitePress
function AddFileInformation_md()
      let infor = "---\n"
      \."title: ".expand("%:t:r")." \n"
      \."date: ".strftime("%Y-%m-%d %H:%M:%S")." \n"
      \."categories:\n"
      \."  - \n"
      \."tags:\n"
      \."  - \n"
      \."---\n"
      \."\n"
      \."Hello,"
      silent  put! =infor
endfunction
autocmd BufNewFile *.md call AddFileInformation_md()
" }}}
