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
Plugin 'tpope/vim-commentary' " Easily comment stuff out
Plugin 'mattn/emmet-vim' " html/css abbreviations
Plugin 'kien/ctrlp.vim'
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
Plugin 'Raimondi/delimitMate'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'sophacles/vim-bundle-mako'
Plugin 'tpope/vim-surround'
Plugin 'scrooloose/nerdtree'
Plugin 'tpope/vim-fugitive'

call vundle#end()

set hidden
set t_Co=256
set colorcolumn=80
set backspace=indent,eol,start
set relativenumber
set number
set laststatus=2
set wildignore+=*/bin/*,*/venv/*,*.pyc
set shiftwidth=4
set softtabstop=4
set expandtab
set autoindent
set foldmethod=indent
set foldnestmax=10
set foldlevelstart=99
set background=dark
set modelines=0
colorscheme solarized

nnoremap ; :
let mapleader = ","

nnoremap <Leader><tab> :call ToggleBg()<CR>

inoremap jj <Esc>

" insert single char with space
nnoremap <Leader><space> i_<esc>r

" split lines with K
nnoremap K i<cr><esc>k$

" Move between splits
nnoremap <C-Y> <C-W><C-H>
nnoremap <C-O> <C-W><C-L>
nnoremap <C-I> <C-W><C-K>
nnoremap <C-U> <C-W><C-J>

" Folding
nnoremap <space> za

" j and k on columns rather than lines
nnoremap j gj
nnoremap k gk

" Y yanks till eol
map Y y$

" 0 puts cursor at first non whitespace char
map 0 ^

" MiniBufExplorer
nnoremap <C-l> :MBEbn<CR>
nnoremap <C-h> :MBEbp<CR>
nnoremap <Leader>q :MBEbd<CR>

" Airline config
let g:airline#extensions#default#section_truncate_width = {'z': 0, 'x': 80, 'y': 80}

" Syntastic
let g:syntastic_python_checkers = ['flake8']

" Gundo
nnoremap <F5> :GundoToggle<CR>

" Emmet
let g:user_emmet_leader_key='<Leader>'
let g:user_emmet_install_global = 0
autocmd FileType mako,html,css,htmldjango EmmetInstall

" Gundo
let g:gundo_close_on_revert=1

let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1

" Easymotion
map <Leader> <Plug>(easymotion-prefix)
map <Leader>l <Plug>(easymotion-lineforward)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>h <Plug>(easymotion-linebackward)
nmap s <Plug>(easymotion-s2)
let g:EasyMotion_startofline = 0

" NERDTree
nmap <Leader>o :NERDTreeToggle<CR>
let NERDTreeQuitOnOpen=1

let g:vim_markdown_folding_disabled=1

" Toggle between dark and light themes
function! ToggleBg()
    if &background=="light"
        set background=dark
    else
        set background=light
    endif
endfunction

filetype plugin indent on
syntax on
