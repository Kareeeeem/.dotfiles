set nocompatible
filetype off

" Backspace through lines
set backspace=indent,eol,start

" Show line numbers
set number

" Show satus line with one file buffer open
set laststatus=2

set wildignore+=*/venv/*,*.pyc

" Start cli options with semicolon
nnoremap ; :

" Map leader to ,
let mapleader = ","

" default indent settings
set shiftwidth=4
set softtabstop=4
set expandtab
set autoindent

" Set up vundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim' " Package manager
Plugin 'Valloric/YouCompleteMe' " Autocompletion
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

call vundle#end()

" Set up colorscheme
set background=dark
colorscheme solarized
" Toggle between dark and light themes
nnoremap <Leader><tab> :call ToggleBg()<CR>

function! ToggleBg()
    if &background=="light"
        set background=dark
    else
        set background=light
    endif
endfunction

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
autocmd FileType html,css EmmetInstall

filetype plugin indent on
syntax on
