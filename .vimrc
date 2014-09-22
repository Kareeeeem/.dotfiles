set nocompatible
filetype off

" Set up vundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim' " Package manager
Plugin 'Valloric/YouCompleteMe'
Plugin 'altercation/vim-colors-solarized' " Solarized colorscheme
Plugin 'fholgado/minibufexpl.vim' " Buffer bar
Plugin 'scrooloose/syntastic' " Syntax checking
Plugin 'bling/vim-airline' " Statusline
Plugin 'sjl/gundo.vim' " Undo through saves
Plugin 'moll/vim-bbye' " Delete buffer without closing window
Plugin 'scrooloose/nerdtree' " Folder tree
Plugin 'tpope/vim-commentary' " Easily comment stuff out
Plugin 'mattn/emmet-vim' " html/css abbreviations
Plugin 'kien/ctrlp.vim'
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
Plugin 'Raimondi/delimitMate'
Plugin 'Lokaltog/vim-easymotion'

call vundle#end()

" Map leader to ,
let mapleader = ","

map , <Plug>(easymotion-prefix)
map <Leader>l <Plug>(easymotion-lineforward)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>h <Plug>(easymotion-linebackward)
let g:EasyMotion_startofline = 0

set colorcolumn=80

let g:vim_markdown_folding_disabled=1

" insert single char with space
nmap <space> i_<esc>r

" split lines with K
nmap K i<cr><esc>k$

" Backspace through lines
set backspace=indent,eol,start

" Show line numbers
set number

" Show satus line with one file buffer open
set laststatus=2

set wildignore+=*/venv/*,*.pyc

" Start cli options with semicolon
nnoremap ; :

" default indent settings
set shiftwidth=4
set softtabstop=4
set expandtab
set autoindent

function! ToggleBg()
    if &background=="light"
        set background=dark
    else
        set background=light
    endif
endfunction

set background=dark
colorscheme solarized

" Toggle between dark and light themes
nnoremap <Leader><tab> :call ToggleBg()<CR>

" MiniBufExplorer
nnoremap <C-l> :MBEbn<CR>
nnoremap <C-h> :MBEbp<CR>

" Folding
set foldmethod=indent
set foldnestmax=1
set foldlevelstart=99
nnoremap <space> za

" Bind leader-q to close buffer while keeping window
nnoremap <Leader>q :Bdelete<CR>

" Airline config
let g:airline#extensions#default#section_truncate_width = {'z': 0, 'x': 80, 'y': 80}

" Syntastic
let g:syntastic_python_checkers = ['flake8']

" Nerdtree
let g:NERDTreeDirArrows=0
let NERDTreeIgnore = ['\.pyc$']
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
map <C-n> :NERDTreeToggle<CR>

" Toggle Gundo
nnoremap <Leader>z :GundoToggle<CR>

" Emmet
let g:user_emmet_leader_key='<Leader>'
" Only use emmet for html css
let g:user_emmet_install_global = 0
autocmd FileType html,css,htmldjango EmmetInstall

" Gundo
let g:gundo_close_on_revert=1

filetype plugin indent on
syntax on
