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
Plug 'ap/vim-buftabline' " Buffers in de tab bar
Plug 'tpope/vim-commentary' " Easily comment stuff out
Plug 'ctrlpvim/ctrlp.vim' " Fuzzy search files/buffers/tags/etc
Plug 'tpope/vim-surround' " Easily wrap text in delimiters or change them
Plug 'tpope/vim-fugitive' " Git intergration
Plug 'moll/vim-bbye' " Delete buffers without affecting windows
Plug 'christoomey/vim-tmux-navigator' " Navigate vim and tmux with Ctrl-[hjkl]
Plug 'jpalardy/vim-slime' " Send input from vim to screen/tmux
Plug 'mitsuhiko/vim-jinja' " Jinja syntax highlighting

Plug 'Valloric/YouCompleteMe', {'do': './install.py --clang-completer'} " Autocompletion

Plug 'plasticboy/vim-markdown', {'for': 'mkd'} " markdown syntax highlighting
Plug 'mattn/emmet-vim', {'for': ['html', 'css', 'htmldjango', 'htmljinja']} " html/css abbreviations
Plug 'hynek/vim-python-pep8-indent', {'for': 'python'} " Better python indentation
Plug 'jmcantrell/vim-virtualenv', {'for': 'python'} " virtualenv support
Plug 'pangloss/vim-javascript', {'for': ['javascript.jsx', 'js']} " Javascript indentation
Plug 'mxw/vim-jsx', {'for': ['javascript.jsx', 'js']} " JSX syntax highlighting / identation
Plug 'rust-lang/rust.vim', {'for': ['rust']} " JSX syntax highlighting / identation

Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'} " a filetree
Plug 'mbbill/undotree', {'on': 'UndotreeToggle'} " An interface for going through the undo tree

call plug#end()

filetype plugin indent on
syntax on

" ===============================
" SECTION 2: Basic settings
" ===============================

" See `:help {setting}` for explanation.


set hidden
set backspace=indent,eol,start
set encoding=utf-8

set laststatus=2
set colorcolumn=80
set background=dark
set number

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

" http://www.techrepublic.com/blog/it-security/turn-off-modeline-support-in-vim/
set modelines=0

" Make sure this directory exists.
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

" wildignore
set wildignore+=*.o
set wildignore+=*.egg
set wildignore+=*.pyc
set wildignore+=*/venv/*
set wildignore+=*/dist/*
set wildignore+=*/*.egg-info/*
set wildignore+=*/__pycache__/*
set wildignore+=*/node_modules/*

" ===============================
" SECTION 3: Key mappings
" ===============================

" Command line mode
" =================

" Expand `%%` to current directory.
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" Normal mode
" ===========

" Because backslash is in a awkward place.
let mapleader = "\<Space>"

" I almost never want to go to the ABSOLUTE beginning of a line
nnoremap 0 ^

" Insert a uuid
inoremap uuid4 '<C-r>=system('python -c "import uuid, sys; sys.stdout.write(str(uuid.uuid4()))"')<CR>'

" Break lines on a comma.
nnoremap <leader>, f,cw,<CR><ESC>

nnoremap <F6> :set paste!<CR>

" Go to last used buffer
nnoremap <Leader><Leader> <C-^>

" Break line
nnoremap K i<cr><esc>k$

" buffers
nnoremap <leader>b :bp<CR>
nnoremap <leader>n :bn<CR>

" Clear search highlighting
nnoremap <F7> :set hlsearch!<CR>

" j and k on columns rather than lines
nnoremap j gj
nnoremap k gk

" Y yanks till eol to be consistent with C and D
nnoremap Y y$

" Highlight last inserted text
nnoremap gV `[v`]

" Visual mode
" ===========

" * and # search for visual selection
xnoremap * :<C-u>call <SID>VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch('?')<CR>?<C-R>=@/<CR><CR>

" keep the visual selection after changing indentation
xnoremap < <gv
xnoremap > >gv

" Search replace visual selection
xnoremap <Leader>r <Esc>:%s/<c-r>=GetVisual()<cr>/

" ===============================
" SECTION 4: Plugin configuration
" ===============================

" Slime
let g:slime_target = 'tmux'
let g:slime_python_ipython = 1

" CtrlP
let g:ctrlp_open_multiple_files = '1r'
let g:ctrlp_open_new_file = 'r'
let g:ctrlp_by_filename = 1
let g:ctrlp_extensions = ['tag']
nnoremap <leader>m :CtrlPMRUFiles<CR>

" bbye
nnoremap <Leader>q :Bdelete<CR>

" Syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_python_checkers = ['flake8']

" Emmet
let g:user_emmet_install_global = 0

" Undotree
nnoremap <F5> :UndotreeToggle<CR>
if !exists('g:undotree_SplitWidth')
    let g:undotree_SplitWidth = 30
endif

" NERDTree
nnoremap <C-n> :NERDTreeToggle<CR>
let g:NERDTreeDirArrows=0
let NERDTreeQuitOnOpen=1
let NERDTreeIgnore = ['\.pyc$', '*egg*']

" YouCompleteMe
let g:ycm_global_ycm_extra_conf = '~/.dotfiles/.ycm_extra_conf.py'
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_collect_identifiers_from_tags_files = 1
nnoremap <leader>g :YcmCompleter GoTo<CR>

" vim-jsx
let g:jsx_ext_required = 0

" Buftabline
let g:buftabline_numbers = 1
let g:buftabline_indicators = 1
let g:buftabline_seperators = 1

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

augroup filetypes
    autocmd!

    " autocmd FileType mkd.markdown setlocal textwidth=79
    " autocmd FileType mkd.markdown setlocal formatoptions+=t
    " autocmd FileType mkd.markdown setlocal formatprg=par\ -79
    " autocmd FileType mkd.markdown nnoremap <buffer> <Leader>1 yypVr=o<ESC>
    " autocmd FileType mkd.markdown nnoremap <buffer> <Leader>2 yypVr-o<ESC>

    autocmd FileType mako,html,css,htmldjango,htmljinja EmmetInstall

    autocmd FileType css,html,htmljinja,javascript.jsx,javascript setlocal shiftwidth=2
    autocmd FileType css,html,htmljinja,javascript.jsx,javascript setlocal softtabstop=2

    autocmd FileType c setlocal formatprg=astyle\ -S

    autocmd FileType htmljinja setlocal commentstring={#\ %s\ #}
augroup END

" ===============================
" SECTION 6: Colorscheme settings
" ===============================

colorscheme ron
hi ColorColumn ctermbg=8
hi Comment ctermfg=8
hi LineNr ctermfg=8
hi SpellBad ctermfg=15
hi SpellCap ctermfg=15
hi TODO ctermfg=15 ctermbg=1
hi link pythonOperator Statement
hi link pythonNumber Structure
hi CtrlPMode1 ctermfg=15
hi link CtrlPMode2 StatusLine
hi StatusLineNC ctermfg=8

" tmux doesn't render italics properly, so let's just remap to standout
if &term == "screen-256color"
    highlight htmlItalic cterm=standout
endif

" ===========================
" SECTION 7: Helper Functions
" ===========================

function! <SID>StripTrailingWhitespaces()
    " prep: save last search, and cursor position.
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
