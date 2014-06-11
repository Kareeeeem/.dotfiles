set nocompatible
filetype off

" Backspace through lines
set backspace=2

" Show line numbers
set number

" Show satus line with one file buffer open
set laststatus=2

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

Plugin 'gmarik/Vundle.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'Lokaltog/vim-distinguished'
Plugin 'tomasr/molokai'
Plugin 'altercation/vim-colors-solarized'
Plugin 'wesgibbs/vim-irblack'
Plugin 'tpope/vim-vividchalk'
Plugin 'nanotech/jellybeans.vim'
Plugin 'fugalh/desert.vim'
Plugin 'fholgado/minibufexpl.vim'
Plugin 'scrooloose/syntastic'
Plugin 'bling/vim-airline'
Plugin 'sjl/gundo.vim'
Plugin 'moll/vim-bbye'
Plugin 'scrooloose/nerdtree'

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
nnoremap <space> za

" Bind leader-q to close buffer while keeping window
nnoremap <Leader>q :Bdelete<CR>

" Airline config
"let g:airline_section_x = ""
"let g:airline_section_y = ""
let g:airline#extensions#default#section_truncate_width = {'z': 0, 'x': 80, 'y': 80}

" Syntastic
let g:syntastic_python_checkers = ['flake8']

" Nerdtree
let g:NERDTreeDirArrows=0
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
map <C-n> :NERDTreeToggle<CR>

filetype plugin indent on
syntax on
