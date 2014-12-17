" ###############################
" Table of contents
"
" SECTION 1: Vundle plugin setup
" SECTION 2: Basic settings
" SECTION 3: Key mappings
" SECTION 4: Plugin configuration
" SECTION 5: Autocommands
" ###############################

set nocompatible
filetype off

" ###############################
" SECTION 1: Vundle plugin setup
" ###############################

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim' " Package manager
Plugin 'Valloric/YouCompleteMe' " Autocompletion (needs to be compiled)
Plugin 'fholgado/minibufexpl.vim' " Buffer bar
Plugin 'scrooloose/syntastic' " Syntax checking
Plugin 'bling/vim-airline' " Statusline
Plugin 'sjl/gundo.vim' " Undo through saves
Plugin 'tpope/vim-commentary' " Easily comment stuff out
Plugin 'mattn/emmet-vim' " html/css abbreviations
Plugin 'kien/ctrlp.vim' " search for files/buffers
Plugin 'godlygeek/tabular' " line up text
Plugin 'plasticboy/vim-markdown' " markdown highlighting
Plugin 'Raimondi/delimitMate' " easier handling of delimiters
Plugin 'tpope/vim-surround' " easily wrap text in delimiters or change them
Plugin 'scrooloose/nerdtree' " a filetree
Plugin 'tpope/vim-fugitive' " git intergration
Plugin 'hynek/vim-python-pep8-indent' " Proper python indentation
Plugin 'moll/vim-bbye' " a better way to delete buffers

call vundle#end()

" ###############################
" SECTION 2: Basic settings
" ###############################

set hidden
set colorcolumn=80
set backspace=indent,eol,start " make backspace work as expected
set number
set laststatus=2 "always show the status line
set wildignore+=*/bin/*,*/venv/*,*.pyc,*.egg,*.egg-info/*
set hlsearch
set incsearch
set autoindent
set cindent
set shiftwidth=4
set softtabstop=4
set expandtab
set foldmethod=indent
set foldnestmax=10
set foldlevelstart=99
set background=dark
set modelines=0 " http://www.techrepublic.com/blog/it-security/turn-off-modeline-support-in-vim/
set formatprg=par\ -79 " format paragraphs with par

" ###############################
" SECTION 3: Key mappings
" ###############################

" because backslash is in a awkward place
let mapleader = ","

" put the original functionality of , on \
nnoremap \ ,

" swap ; and : because the latter is used much more often
nnoremap ; :
nnoremap : ;

" remove trailing whitespace
nnoremap <Leader>w :%s/\s\+$//ge<CR>

" jump outside delimiters
inoremap kj <Esc>/[]})'"]<CR>: nohl<CR>a

" because esc is too far away and when are you gonna type jj?
inoremap jj <Esc>

" quickly insert a single char
nnoremap <Leader><space> i_<esc>r

" because we map MBEpb to J
nnoremap <Leader>j J

" break line and return to the previous one
nnoremap <Leader>k i<cr><esc>k$

" Cancel searchhighlighting
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
map Y y$

" keep the visual selection after changing indentation
vnoremap < <gv
vnoremap > >gv

" 0 puts cursor at first non whitespace char
map 0 ^

" format C code variable assignments
vnoremap <Leader>t :Tab/\(const\\|static\)\@<!\s\+/l0l0l0<CR>

" MiniBufExplorer next and previous buffer
nnoremap K :MBEbn<CR>
nnoremap J :MBEbp<CR>
nnoremap <Leader>m :MBEToggle<CR>
let g:miniBufExplorerAutoStart = 0

" ###############################
" SECTION 4: Plugin configuration
" ###############################

let g:ctrlp_open_new_file = 'r'
let g:ctrlp_match_window = 'max:10,results:10'

nnoremap <Leader>p :CtrlPBuffer<CR>

nnoremap <Leader>q :Bdelete<CR>

" Airline config
let g:airline#extensions#default#section_truncate_width = {'z': 0, 'x': 80, 'y': 80}

" Syntastic (install flake8 system wide
let g:syntastic_python_checkers = ['flake8']

" Gundo
nnoremap <F5> :GundoToggle<CR>

" Emmet
let g:user_emmet_leader_key='<Leader>'
let g:user_emmet_install_global = 0
autocmd FileType mako,html,css,htmldjango EmmetInstall

" Gundo
let g:gundo_close_on_revert=1

" NERDTree
nnoremap <C-n> :NERDTreeToggle<CR>
let NERDTreeQuitOnOpen=1
let g:NERDTreeDirArrows=0

let g:vim_markdown_folding_disabled=1

" YouCompleteMe
let g:ycm_global_ycm_extra_conf = '~/.dotfiles/.ycm_extra_conf.py'
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1

" SECTION 5: Autocommands
autocmd FileType mkd set textwidth=79

" format opening brackets in C code, vim is being annoying about this
autocmd FileType c inoremap {<CR> <CR>{<CR>}<Esc>O

filetype plugin indent on
syntax on

" ###############################
" SECTION 6: Colorscheme settings
" ###############################

" tmux doesn't render italics properly, so let's just remap to standout
if &term == "screen-256color"
    highlight htmlItalic cterm=standout
endif

highlight ColorColumn ctermbg=236
highlight Comment ctermfg=240
highlight LineNr ctermfg=240
