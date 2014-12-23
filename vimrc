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
set wildignore+=[^~]/bin/*,*/venv/*,*.pyc,*.egg,*.egg-info/*
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

" Switch buffers the native way
nnoremap <C-t> :buffers<CR>:buffer<Space>

" put the original functionality of , on \
nnoremap \ ,

" Bubble multiple lines
vnoremap <C-k> xkP`[V`]
vnoremap <C-j> xp`[V`]

" swap ; and : because the latter is used much more often
nnoremap ; :
nnoremap : ;

" jump outside delimiters
inoremap kj <Esc>/[]})`'"]<CR>:noh<CR>a

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

" Search replace word under cursor
nnoremap <C-r> :%s/\<<C-r><C-w>\>/

" Find delimiter without search highlighting or putting it as the last search
" in search history
function! <SID>FindDelimiter()
    set nohlsearch
    let _s=@/
    execute "normal! /[]})`'\"]\<CR>"
    let @/=_s
    set hlsearch
endfunction
inoremap <silent> kj <Esc>:call <SID>FindDelimiter()<CR>a

" Strip whitespace withour changing cursor position or having it in the search
" history
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
nnoremap <silent> <Leader>w :call <SID>StripTrailingWhitespaces()<CR>

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

" Start the find and replace command across the entire file
vnoremap <C-r> <Esc>:%s/<c-r>=GetVisual()<cr>/

" Resize vertical splits
nnoremap <Leader>vr :vertical resize 
nnoremap <Leader>] :vertical resize +5<CR>
nnoremap <Leader>[ :vertical resize -5<CR>

" ###############################
" SECTION 4: Plugin configuration
" ###############################

nnoremap K :bn<CR>
nnoremap J :bp<CR>
" MiniBufExplorer next and previous buffer
" nnoremap K :MBEbn<CR>
" nnoremap J :MBEbp<CR>
nnoremap <Leader>m :MBEToggle<CR>
let g:miniBufExplorerAutoStart = 0

let g:ctrlp_open_new_file = 'r'
let g:ctrlp_match_window = 'max:13,results:13'

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
let g:ycm_global_ycm_extra_conf = '~/dotfiles/.ycm_extra_conf.py'
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

colorscheme ron
set cursorline
hi CursorLine cterm=none ctermbg=000

highlight ColorColumn ctermbg=236
highlight Comment cterm=standout ctermfg=240
highlight LineNr ctermfg=240

" if hostname() == "idle"
"     highlight LineNr ctermfg=240
" endif

" tmux doesn't render italics properly, so let's just remap to standout
if &term == "screen-256color"
    highlight htmlItalic cterm=standout
endif
