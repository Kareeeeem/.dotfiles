" ===============================
" TABLE OF CONTENTS
"
" SECTION 1: Vim-plug setup
" SECTION 2: Basic settings
" SECTION 3: Key mappings
" SECTION 4: Plugin configuration
" SECTION 5: Autocommands
" SECTION 6: Colorscheme settings
" SECTION 7: Helper functions
" ===============================

set nocompatible
filetype off

" ===============================
" SECTION 1: Plugin setup
" ===============================

" if Vim-Plug doesn't exist yet
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.vim/plugged')

Plug 'scrooloose/syntastic' " Syntax checking
Plug 'ap/vim-buftabline' " Lightweight bufferline like the vim tabline
Plug 'tpope/vim-commentary' " Easily comment stuff out
Plug 'kien/ctrlp.vim' " Fuzzy search files/buffers/tags/etc
Plug 'godlygeek/tabular' " line up text
Plug 'tpope/vim-surround' " Easily wrap text in delimiters or change them
Plug 'tpope/vim-fugitive' " Git intergration
Plug 'moll/vim-bbye' " Deleete buffers without affecting windows
Plug 'christoomey/vim-tmux-navigator' " Navigate vim and tmux with Ctrl-[hjkl]
Plug 'jpalardy/vim-slime' " Send input from vim to screen/tmux
Plug 'vim-scripts/Align'
Plug 'NLKNguyen/papercolor-theme'

" Plugins with a post-install hook
" ================================

Plug 'Valloric/YouCompleteMe', {'do': './install.sh --clang-completer'}
Plug 'Shougo/vimproc.vim', {'do': 'make'} " Dependency for ghc-mod

" Plugins loaded for specific filetypes
" =====================================

Plug 'plasticboy/vim-markdown', {'for': 'mkd'} " markdown syntax highlighting
Plug 'mattn/emmet-vim', {'for': ['html', 'css', 'htmldjango']} " html/css abbreviations
Plug 'hynek/vim-python-pep8-indent', {'for': 'python'} " Better python indentation
Plug 'jmcantrell/vim-virtualenv', {'for': 'python'} " virtualenv support
Plug 'eagletmt/neco-ghc', {'for': 'haskell'} " haskell autocomplete
Plug 'eagletmt/ghcmod-vim', {'for': 'haskell'} " Ghc-mod support
Plug 'raichoo/haskell-vim', {'for': 'haskell'} " Haskell syntax highlighting and indentation

" Plugins loaded on running a command
" ===================================

Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'} " a filetree
Plug 'mbbill/undotree', {'on': 'UndotreeToggle'} "  Undo through saves

call plug#end()

" ===============================
" SECTION 2: Basic settings
" ===============================

set hidden " enable hidden buffers
set spelllang=nl
set encoding=utf-8
set fileencoding=utf-8
set colorcolumn=80
set background=dark
set cursorline
set number
set backspace=indent,eol,start " make backspace work as expected
set laststatus=2 "always show the status line
set wildignore+=*/venv/**/*,*.pyc,*.egg,*.egg-info/**/*,*.o,*/__pycache__/**/*
set hlsearch
set incsearch
set ignorecase
set smartcase
set autoindent
set shiftwidth=4
set softtabstop=4
set expandtab
set foldenable
set foldmethod=indent
set foldnestmax=10
set foldlevelstart=10
set modelines=0 " http://www.techrepublic.com/blog/it-security/turn-off-modeline-support-in-vim/
set undodir=~/.vim/undodir/
set undofile
set scrolloff=3

" statusline
set statusline=%n\ %t\ %y
set statusline+=\ %h%m%r
set statusline+=\ %<%{fugitive#statusline()}
set statusline+=%= " right alignment from this point
set statusline+=%-14.(%l,%c%V%)\ %P
" syntastic statusline
set statusline+=\ %#Error#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" set winwidth=84

" We have to have a winheight bigger than we want to set winminheight. But if
" we set winheight to be huge before winminheight, the winminheight set will
" fail.

" set winheight=5
" set winminheight=5
" set winheight=999

" ===============================
" SECTION 3: Key mappings
" ===============================

" Command line mode
" =================

cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" a because backslash is in a awkward place
let mapleader = "\<Space>"

" Normal mode
" ===========

map <Leader>c :colorscheme

" Switch buffers the native way
nnoremap <Leader>b :buffers<CR>:buffer<Space>
nnoremap K :bn<CR>
nnoremap J :bp<CR>

" put the original functionality of , on \
" nnoremap \ ,

" swap ; and : because the latter is used much more often
" nnoremap ; :
" nnoremap : ;

" start external command with just !
nnoremap ! :!

" because we map bp to J
nnoremap <Leader>j J

" break line and return to the previous one
nnoremap <Leader>k i<cr><esc>k$

" Clear searchhighlighting
nnoremap <Leader>n :nohl<CR>

" Move between splits
" Is now taken care of by Tmux navigator
" nnoremap <C-H> <C-W><C-H>
" nnoremap <C-L> <C-W><C-L>
" nnoremap <C-K> <C-W><C-K>
" nnoremap <C-J> <C-W><C-J>

" j and k on columns rather than lines
nnoremap j gj
nnoremap k gk

" Y yanks till eol
nnoremap Y y$

" 0 puts cursor at first non whitespace char
nnoremap 0 ^

" Resize vertical splits
nnoremap <Leader>vr :vertical resize 85
nnoremap <Leader>] :vertical resize +5<CR>
nnoremap <Leader>[ :vertical resize -5<CR>

" Search replace word under cursor
nnoremap <Leader>r :%s/\<<C-r><C-w>\>/

" Strip whitespace withour changing cursor position or having it in the search
" history
nnoremap <silent> <Leader>w :call <SID>StripTrailingWhitespaces()<CR>

" Highlight last inserted text
nnoremap gV `[v`]

" Insert mode
" ===========

" because esc is too far away and when are you gonna type jj?
" Lets try with just <C-[>
" inoremap jj <Esc>

" Find delimiter without search highlighting or putting it as the last search
" in search history
" This screws up undo
" inoremap <silent> kj <Esc>:call <SID>FindDelimiter()<CR>a

" Visual mode
" ===========

" Bubble multiple lines
xnoremap <c-j> xp`[v`]
xnoremap <c-k> xkp`[v`]

" * and # search for visual selection
xnoremap * :<C-u>call <SID>VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch('?')<CR>?<C-R>=@/<CR><CR>

" keep the visual selection after changing indentation
xnoremap < <gv
xnoremap > >gv

" Start the find and replace command for visually selected text
xnoremap <Leader>r <Esc>:%s/<c-r>=GetVisual()<cr>/

" ===============================
" SECTION 4: Plugin configuration
" ===============================

" Buftabline
let g:buftabline_indicators = 1 " Show modified indicator

" Align
let g:loaded_AlignMapsPlugin=1
" Align on equal signs
noremap <Leader>a= :Align =<CR>
" Align on commas
noremap <Leader>a, :Align ,<CR>
" Align on pipes
noremap <Leader>a<bar> :Align <bar><CR>
" Prompt for align character
noremap <leader>ap :Align

" Ghc-mod

nnoremap <silent> <leader>ht :GhcModType<CR>
nnoremap <silent> <leader>hT :GhcModTypeInsert<CR>

" Tagbar
nnoremap <F8> :TagbarToggle<CR>

" Slime
let g:slime_target = 'tmux'
let g:slime_python_ipython = 1

" CtrlP
let g:ctrlp_match_window = 'max:13,results:13'
let g:ctrlp_open_multiple_files = '1r'
let g:ctrlp_open_new_file = 'r'
let g:ctrlp_by_filename = 1
nnoremap <Leader>t :CtrlPTag<CR>
nnoremap <Leader>m :CtrlPMRUFiles<CR>
nnoremap <Leader>b :CtrlPBuffer<CR>

" bbye
nnoremap <Leader>q :Bdelete<CR>

" Syntastic (install flake8 system wide)
let g:syntastic_python_checkers = ['flake8']
let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_wq = 0

" Emmet
let g:user_emmet_leader_key='<Leader>'
let g:user_emmet_install_global = 0

" Undotree
nnoremap <F5> :UndotreeToggle<CR>
if !exists('g:undotree_SplitWidth')
    let g:undotree_SplitWidth = 30
endif

" NERDTree
nnoremap <C-n> :NERDTreeToggle<CR>
let NERDTreeQuitOnOpen=1
let g:NERDTreeDirArrows=0
let NERDTreeIgnore = ['\.pyc$', '*egg*']

" YouCompleteMe
let g:ycm_global_ycm_extra_conf = '~/.dotfiles/.ycm_extra_conf.py'
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_filetype_blacklist = {'mkd': 1}
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_semantic_triggers = {'haskell' : ['.']}


" =======================
" SECTION 5: Autocommands
" =======================

augroup write_file
    autocmd!
    autocmd BufWritePre * call <SID>StripTrailingWhitespaces()
    " If git-tags git hook installed run it on every save
    autocmd BufWritePost *
        \ if exists('b:git_dir') && executable(b:git_dir.'/hooks/git-tags') |
        \   call system('"'.b:git_dir.'/hooks/git-tags" &') |
        \ endif
augroup END

augroup emmet
    autocmd!
    autocmd FileType mako,html,css,htmldjango EmmetInstall
augroup END

augroup filetype_mkd
    autocmd!
    autocmd FileType mkd setlocal textwidth=79
    autocmd FileType mkd setlocal formatoptions+=t
    autocmd FileType mkd setlocal formatprg=par\ -79
augroup END

augroup filetype_haskell
    autocmd!
    autocmd FileType haskell setlocal tabstop=8
    autocmd FileType haskell setlocal shiftround
    autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc
    autocmd FileType haskell inoremap <c-l> <space>-><space>
    autocmd FileType haskell inoremap <c-l><c-k> <space>=><space>
    autocmd FileType haskell nnoremap <Leader>n :noh<CR>:GhcModTypeClear<CR>
augroup END

augroup filetype_c
    autocmd!
    autocmd FileType c setlocal formatprg=astyle\ -S
augroup END

filetype plugin indent on
syntax on

" ===============================
" SECTION 6: Colorscheme settings
" ===============================

" colorscheme atom-dark-256

colorscheme ron
hi ColorColumn ctermbg=8
hi Comment ctermfg=8
hi LineNr ctermfg=8
hi CursorLine cterm=none ctermbg=0

hi SpellBad ctermfg=15
hi SpellCap ctermfg=15

hi link pythonOperator Statement
hi link pythonNumber Structure

hi CtrlPMode1 ctermfg=15
hi link CtrlPMode2 StatusLine

" tmux doesn't render italics properly, so let's just remap to standout
if &term == "screen-256color"
    highlight htmlItalic cterm=standout
endif

" ===========================
" SECTION 7: Helper Functions
" ===========================

function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//ge
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction

" I got the following from:
" https://github.com/bryankennedy/vimrc/blob/master/vimrc#L562-L599

" Escape special characters in a string for exact matching.
" This is useful to copying strings from the file to the search tool
" Based on this - http://peterodding.com/code/vim/profile/autoload/xolox/escape.vim
function! EscapeString (string)
    let string=a:string
    " Escape regex characters
    let string = escape(string, '^$.*\/~[]')
    " Escape the line endings
    let string = substitute(string, '\n', '\\n', 'g')
    return string
endfunction

" Get the current visual block for search and replaces
" This function passed the visual block through a string escape function
" Based on this - http://stackoverflow.com/questions/676600/vim-replace-selected-text/677918#677918
function! GetVisual() range
    " Save the current register and clipboard
    let reg_save = getreg('"')
    let regtype_save = getregtype('"')
    let cb_save = &clipboard
    set clipboard&
    " Put the current visual selection in the " register
    normal! ""gvy
    let selection = getreg('"')
    " Put the saved registers and clipboards back
    call setreg('"', reg_save, regtype_save)
    let &clipboard = cb_save
    "Escape any special characters in the selection
    let escaped_selection = EscapeString(selection)
    return escaped_selection
endfunction

" from http://got-ravings.blogspot.com/2008/07/vim-pr0n-visual-search-mappings.html
" makes * and # work on visual mode too.
function! s:VSetSearch(cmdtype)
    let temp = @s
    norm! gv"sy
    let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
    let @s = temp
endfunction

function! <SID>FindDelimiter()
    set nohlsearch
    let _s=@/
    execute "normal! /[]})`'\"]\<CR>"
    let @/=_s
    set hlsearch
endfunction
