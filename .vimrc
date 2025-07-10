"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Maintainer:
"   Alowree XU
"   alowree@hotmail.com
" Start date:
"   Fri 2025-04-04 21:09:42 +0800
" Last updated:
"   Fri 2025-07-04 11:21:02 +0800
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
Plug 'bullets-vim/bullets.vim'
Plug 'vim-airline/vim-airline'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-markdown'
Plug 'ap/vim-css-color'
" Plug 'morhetz/gruvbox'
call plug#end()
" }}}

let mapleader = " "

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
" Autoload files that have changed outside of Vim
set autoread

autocmd FocusGained,BufEnter * silent! checktime
autocmd BufWritePost * checktime

" Use system clipboard
"" unnamed register "* (Linux)
"" unnamedplus register "+ (Linux and macOS)
" This allows you to copy and paste between Vim and other applications
" Use the system clipboard for all yank, delete, change and put operations
set clipboard=unnamed

" Don't show intro
set shortmess+=I

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set 8 lines to the cursor - when moving vertically using j/k
set scrolloff=5

" Avoid garbled characters in Chinese language windows OS
let $LANG='en'
set langmenu=en
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

" Turn on the Wild menu
"
" This enables the viusal menu
" It draws the list of matches for you to see
set wildmenu

" This defines the behavior of the Tab key
" when that menu is active
set wildmode=longest:full,full

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
" A buffer is marked as ¿hidden¿ if it has unsaved changes, and it is not currently loaded in a window
" if you try and quit Vim while there are hidden buffers, you will raise an error:
" E162: No write since last change for buffer ¿a.txt¿
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

" How long Vim highlights a matching bracket, in tenths of a second
set matchtime=2

" Show incomplete commands
set showcmd

" Set built-in file system explorer to use layout similar to the NERDTree plugin
let g:netrw_liststyle=3


" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500


" Add a bit extra margin to the left
set foldcolumn=1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax on

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
set fileencoding=utf-8
set fileencodings=utf-8,ucs-bom,default,latin1

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

" Be smart when using tabs
set smarttab

" 1 tab == 4 spaces
" The number of spaces inserted for a tab (used for auto indenting)
set shiftwidth=4

" Set tab size in spaces (this is for manual indenting)
set tabstop=4

" To visualize tabs and trailing spaces
set list
set listchars=tab:»\ ,trail:·,nbsp:¿

" Linebreak on 500 characters
set lbr
set tw=500

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines


" To persist undo history between sessions
set undodir=~/.vim/tmp/undodir
set undofile

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

nmap <leader>ww :w<cr>
nmap <leader>qq :wq<cr>

nmap <leader>v :edit $MYVIMRC<cr>
nmap <leader>so :source ~/.vimrc<CR>

nmap <leader>wk :e ~/Documents/Weekly.md<cr>
nmap <leader>x :e ~/Documents/buffer.md<cr>

" Disable highlight when <Esc> is pressed
map <silent> <Esc> :noh<cr>

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
map <leader>te :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove
map <leader>tn :tabnext<cr>

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
abbrev <expr> dt() strftime("%a %Y-%m-%d %H:%M:%S %z")
nnoremap <F5> a<C-R>=strftime('%a %Y-%m-%d %H:%M:%S %z')<CR><Esc>
inoremap <F5> <C-R>=strftime('%a %Y-%m-%d %H:%M:%S %z')<CR>

" Useful tricks for keying in the arrow
" The iabbrev command in Vim requires a non-keyword character
" (like a space or enter) to be typed after the abbreviation
" to trigger the expansion.
iabbrev >> →
iabbrev << ←
iabbrev ^^ ↑
iabbrev VV ↓


" Useful tricks for keying in the Chinese quotation marks
inoremap 【【 「
inoremap 】】 」
inoremap 《《 『
inoremap 》》 』

" Abbreviations
iabbrev btw By the way,
iabbrev fyi For your information —
iabbrev asap as soon as possible.
iabbrev fedex FedEx
iabbrev dhl DHL
iabbrev ndl Nolan Digital Limited
iabbrev tcl Twine Company Limited


""""""""""""""""""""""""""""""
" STATUS LINE ------------------------------------------------------------ {{{
" Purely manual, withouth plugins such as vim-airline
" Will be overwritten after you install vim-airline
""""""""""""""""""""""""""""""

" https://github.com/vim-airline/vim-airline/blob/ebb89a0846ff8b8bc64579155d661b825f97d3f2/doc/airline.txt
"vim-airline/vim-airline
let g:airline#extensions#tabline#enabled = 1               "显示窗口的 tab 和 buffer
" let g:airline_powerline_fonts = 1                          "开启支持 powerline 字体
" let g:airline#extensions#tabline#formatter = 'unique_tail' "顶部缓存只显示文件名

" airline-customziation
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

let g:airline_left_sep = ''
" let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
" let g:airline_right_alt_sep = ''

" let g:airline_symbols.branch = ''

" let g:airline_symbols.linenr = ' ㏑ '
let g:airline_symbols.colnr = ' ℅ :'                         "列标志，默认标志乱码

" let g:airline_symbols.readonly = ''
let g:airline_symbols.maxlinenr = ' ☰'
let g:airline_symbols.maxlinenr = ' '
" let g:airline_symbols.dirty = '⚡'

" }}}

" Don't show the mode, since it's already in the status line
set noshowmode

" Always show the status line
set laststatus=2

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""



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
noremap <leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm


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

" Format certain files on save
autocmd BufWritePre *.js,*.jsx,*.ts,*.tsx,*.json,*.css,*.scss,*.html,*.vue,*.md call CocAction('format')
" }}}
