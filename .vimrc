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
Plugin 'tpope/vim-surround'
Plugin 'scrooloose/nerdtree'
Plugin 'tpope/vim-fugitive'
Plugin 'Chiel92/vim-autoformat'

call vundle#end()

set hidden
set colorcolumn=80
set backspace=indent,eol,start
set number
set laststatus=2
set wildignore+=*/bin/*,*/venv/*,*.pyc
set autoindent
set encoding=utf-8
set cindent
set shiftwidth=4
set softtabstop=4
set expandtab
set foldmethod=indent
set foldnestmax=10
set foldlevelstart=99
set background=dark
set modelines=0
set formatprg=par\ -79
set nocursorline

nnoremap ; :
nnoremap : ;

let mapleader = ","

" nnoremap <Leader><tab> :call ToggleBg()<CR>

inoremap kj <Esc>/[]})'"]<CR>a

inoremap jj <Esc>

" insert single char with space
nnoremap <Leader><space> i_<esc>r

" join lines with leader j
nnoremap <Leader>j J
" split lines with leader k
nnoremap <Leader>k i<cr><esc>k$

" Move between splits
nnoremap <C-H> <C-W><C-H>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-J> <C-W><C-J>

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
nnoremap K :MBEbn<CR>
nnoremap J :MBEbp<CR>
nnoremap <Leader>q :MBEbd<CR>

vnoremap <Leader>t :Tab/\(const\\|static\)\@<!\s\+/l0l0l0<CR>

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

" NERDTree
nmap <Leader>o :NERDTreeToggle<CR>
let NERDTreeQuitOnOpen=1

let g:vim_markdown_folding_disabled=1

" YouCompleteMe
let g:ycm_global_ycm_extra_conf = '~/.dotfiles/.ycm_extra_conf.py'

" Autoformat
let g:formatprg_c = "astyle"
" let g:formatprg_args_expr_c = '"--style=java --S"'

autocmd FileType mkd set textwidth=79 

autocmd FileType c inoremap {<CR> <CR>{<CR>}<Esc>O

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

highlight Comment ctermfg=240
highlight ColorColumn ctermbg=236
highlight LineNr ctermfg=240
" highlight link PythonDecorator Special
