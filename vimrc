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
" SECTION 1: Vundle plugin setup
" ===============================

" if Plug doesn't exist yet
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.vim/plugged')

Plug 'scrooloose/syntastic' " Syntax checking
Plug 'bling/vim-airline' " Statusline
Plug 'sjl/gundo.vim' " Undo through saves
Plug 'tpope/vim-commentary' " Easily comment stuff out
Plug 'kien/ctrlp.vim' " search for files/buffers
Plug 'godlygeek/tabular' " line up text
Plug 'Raimondi/delimitMate' " easier handling of delimiters
Plug 'tpope/vim-surround' " easily wrap text in delimiters or change them
Plug 'tpope/vim-fugitive' " git intergration
Plug 'moll/vim-bbye' " a better way to delete buffers
Plug 'w0ng/vim-hybrid' " colorscheme
Plug 'jmcantrell/vim-virtualenv' " virtulenv support

" Plugins that require compiling or something
Plug 'Valloric/YouCompleteMe', {'do': './install.sh --clang-completer'}

" Plugins loaded for specific filetypes
Plug 'plasticboy/vim-markdown', {'for': 'mkd'} " markdown highlighting
Plug 'mattn/emmet-vim', {'for': ['html', 'css', 'htmldjango', 'mako']} " html/css abbreviations
Plug 'hynek/vim-python-pep8-indent', {'for': 'python'} " Better python indentation
Plug 'sophacles/vim-bundle-mako', {'for': 'mako'} " Mako syntax highlighting
Plug 'junegunn/goyo.vim', {'for': 'mkd'} " distraction free writing
Plug 'jmcantrell/vim-virtualenv', {'for': 'python'} " virtualenv support

" Plugins loaded on running a command
Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'} " a filetree

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
set wildignore+=*/venv/*,*.pyc,*.egg,*.egg-info/*,*.o,*/__pycache__/*

set hlsearch
set incsearch
" set ignorecase

set autoindent
set shiftwidth=4
set softtabstop=4
set expandtab

set foldenable
set foldmethod=indent
set foldnestmax=10
set foldlevelstart=10

set modelines=0 " http://www.techrepublic.com/blog/it-security/turn-off-modeline-support-in-vim/
set scrolloff=3
set lazyredraw

" ===============================
" SECTION 3: Key mappings
" ===============================

" because backslash is in a awkward place
let mapleader = ","

" ===========
" Normal mode
" ===========

" Switch buffers the native way
nnoremap <Leader>b :buffers<CR>:buffer<Space>
nnoremap K :bn<CR>
nnoremap J :bp<CR>

" put the original functionality of , on \
nnoremap \ ,

" swap ; and : because the latter is used much more often
nnoremap ; :
nnoremap : ;

" start external command with just !
nnoremap ! :!

" because we map bp to J
nnoremap <Leader>j J

" break line and return to the previous one
nnoremap <Leader>k i<cr><esc>k$

" Clear searchhighlighting
nnoremap <Leader>n :nohl<CR>

" Move between splits
nnoremap <C-H> <C-W><C-H>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-J> <C-W><C-J>

" j and k on columns rather than lines
nnoremap j gj
nnoremap k gk

" Y yanks till eol
nnoremap Y y$

" 0 puts cursor at first non whitespace char
nnoremap 0 ^

" Resize vertical splits
nnoremap <Leader>vr :vertical resize
nnoremap <Leader>] :vertical resize +5<CR>
nnoremap <Leader>[ :vertical resize -5<CR>

" Search replace word under cursor
nnoremap <Leader>r :%s/\<<C-r><C-w>\>/

" Strip whitespace withour changing cursor position or having it in the search
" history
nnoremap <silent> <Leader>w :call <SID>StripTrailingWhitespaces()<CR>

" Highlight last inserted text
nnoremap gV `[v`]

" ===========
" Insert mode
" ===========

" because esc is too far away and when are you gonna type jj?
inoremap jj <Esc>

" Find delimiter without search highlighting or putting it as the last search
" in search history
inoremap <silent> kj <Esc>:call <SID>FindDelimiter()<CR>a

" ===========
" Visual mode
" ===========

" Bubble multiple lines
vnoremap <C-k> xkP`[V`]
vnoremap <C-j> xp`[V`]

" * and # search for visual selection
xnoremap * :<C-u>call <SID>VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch('?')<CR>?<C-R>=@/<CR><CR>

" keep the visual selection after changing indentation
vnoremap < <gv
vnoremap > >gv

" Start the find and replace command for visually selected text
vnoremap <Leader>r <Esc>:%s/<c-r>=GetVisual()<cr>/

" ===============================
" SECTION 4: Plugin configuration
" ===============================

" CtrlP
let g:ctrlp_match_window = 'max:13,results:13'
let g:ctrlp_open_multiple_files = '1r'
let g:ctrlp_open_new_file = 'r'
nnoremap <Leader>t :CtrlPTag<CR>

" bbye
nnoremap <Leader>q :Bdelete<CR>

" Airline
let g:airline#extensions#default#section_truncate_width = {'z': 0, 'x': 80, 'y': 80}
let g:airline#extensions#tabline#enabled = 1 " Enable the list of buffers
let g:airline#extensions#tabline#fnamemod = ':t' " Show just the filename

" Syntastic (install flake8 system wide)
let g:syntastic_python_checkers = ['flake8']

" Gundo
nnoremap <F5> :GundoToggle<CR>

" Emmet
let g:user_emmet_leader_key='<Leader>'
let g:user_emmet_install_global = 0

" Gundo
let g:gundo_close_on_revert=1

" NERDTree
nnoremap <C-n> :NERDTreeToggle<CR>
let NERDTreeQuitOnOpen=1
let g:NERDTreeDirArrows=0

" YouCompleteMe
let g:ycm_global_ycm_extra_conf = '~/.dotfiles/.ycm_extra_conf.py'
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_filetype_blacklist = {'mkd': 1}

" =======================
" SECTION 5: Autocommands
" =======================

augroup close_file
    autocmd!
    autocmd BufWritePre * call <SID>StripTrailingWhitespaces()
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

" augroup filetype_c
"     autocmd!
"     autocmd FileType c vnoremap <Leader>v :Tab/\(const\\|static\)\@<!\s\+/l0l0l0<CR>
" augroup END

filetype plugin indent on
syntax on

" ===============================
" SECTION 6: Colorscheme settings
" ===============================

colorscheme ron
hi ColorColumn ctermbg=8
hi Comment ctermfg=8
hi LineNr ctermfg=8
hi CursorLine cterm=none ctermbg=0

hi SpellBad ctermfg=0
hi SpellCap ctermfg=0

hi link pythonOperator Statement

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
