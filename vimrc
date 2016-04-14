set nocompatible
filetype off

call plug#begin('~/.vim/plugged')

Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --all'}
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'scrooloose/syntastic'
" Plug 'ap/vim-buftabline'
Plug 'bling/vim-bufferline'
Plug 'jpalardy/vim-slime'
Plug 'itchyny/vim-gitbranch'
Plug 'Kareeeeem/vim-256noir'
" Plug 'Valloric/YouCompleteMe', {'do': './install.py --clang-completer'}
Plug 'mattn/emmet-vim', {'for': ['html', 'css', 'htmldjango', 'htmljinja']}
Plug 'mitsuhiko/vim-jinja', {'for': ['html', 'htmldjango', 'htmljinja']}
Plug 'hynek/vim-python-pep8-indent', {'for': 'python'}
Plug 'pangloss/vim-javascript', {'branch': 'develop', 'for': ['javascript.jsx', 'javascript']}
" Plug 'mxw/vim-jsx', {'for': ['javascript.jsx', 'javascript']}
Plug 'mbbill/undotree', {'on': 'UndotreeToggle'}
Plug 'robertmeta/nofrils'
Plug 'pbrisbin/vim-colors-off'
Plug 'ajh17/VimCompletesMe'

call plug#end()

filetype plugin indent on
syntax on

set hidden
set number
set hlsearch
set incsearch
set nofoldenable
set ignorecase
set smartcase
set expandtab
set autoindent
set shiftwidth=4
set softtabstop=4
set colorcolumn=80
set scrolloff=3
set formatoptions+=rj
set formatoptions-=o
set backspace=indent,eol,start
set encoding=utf-8
set dir=~/.vim/tmp
set undodir=~/.vim/undodir/
set undofile
set tags=.git/tags
set nowrap

" statusline
set laststatus=2
set statusline=%n\ %.20F\ %y
set statusline+=\ %h%m%r
set statusline+=%{gitbranch#name()}
set statusline+=%= " right alignment from this point
set statusline+=%-14.(%l,%c%V%)\ %P
set statusline+=\ %#Error#%{SyntasticStatuslineFlag()}%*

" wildignore
set wildignore+=*.o
set wildignore+=*.egg
set wildignore+=*.pyc
set wildignore+=*/venv/*
set wildignore+=*/dist/*
set wildignore+=*/*.egg-info/*
set wildignore+=*/__pycache__/*
set wildignore+=*/node_modules/*

if executable("ag")
    set grepprg=ag\ --nogroup\ --nocolor\ --ignore-case\ --column
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

" Expand `%%` to current directory.
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'
" Because backslash is in a awkward place.
let mapleader = "\<Space>"
" I almost never want to go to the ABSOLUTE beginning of a line
nnoremap 0 ^

nnoremap <leader>, f,cw,<CR><ESC>
" Go to last used buffer
nnoremap <Leader><Leader> <C-^>
" Break line
nnoremap K i<cr><esc>k$
" Toggle search highlighting
nnoremap <F7> :set hlsearch!<CR>
" Toggle paste
nnoremap <F6> :set paste!<CR>
" j and k on columns rather than lines
nnoremap j gj
nnoremap k gk
" Y yanks till eol to be consistent with C and D
nnoremap Y y$
" Highlight last inserted text
nnoremap gV `[v`]
" keep the visual selection after changing indentation
xnoremap < <gv
xnoremap > >gv

nnoremap <F1> :bp<CR>
nnoremap <F2> :bn<CR>

nnoremap <leader>q :bd<CR>

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" fzf
nnoremap <C-p> :Files<CR>
nnoremap <leader>t :Tags<CR>
nnoremap <leader>m :History<CR>

" Slime
let g:slime_target = 'tmux'
let g:slime_python_ipython = 1

" Syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_python_flake8_args='--ignore=E501'
let g:syntastic_python_checkers = ['flake8']
let g:syntastic_javascript_checkers = ['eslint']

let g:syntastic_mode_map = {
        \ "mode": "active",
        \ "passive_filetypes": ["javascript", "javascript.jsx"] }
nnoremap <leader>c :SyntasticCheck<cr>

" Emmet
let g:user_emmet_install_global = 0

" Undotree
nnoremap <F5> :UndotreeToggle<CR>
if !exists('g:undotree_SplitWidth')
    let g:undotree_SplitWidth = 30
endif

" let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
" let g:ycm_autoclose_preview_window_after_completion = 1
" let g:ycm_collect_identifiers_from_tags_files = 1
" let g:ycm_filetype_specific_completion_to_disable = {
"             \ 'javascript': 1,
"             \ 'javascript.jsx': 1,
"             \ 'jsx': 1,
"             \ }

" vim-jsx
let g:jsx_ext_required = 0

" Buftabline
" let g:buftabline_numbers = 1
" let g:buftabline_indicators = 1
" let g:buftabline_seperators = 1

" This keeps the sign column visible at all times. Can't stand the
" twitching when linting for errors. http://superuser.com/a/558885
augroup dummysign
    au!
    autocmd BufEnter * sign define dummy
    autocmd BufEnter * execute 'sign place 9999 line=1 name=dummy buffer=' . bufnr('')
augroup END

augroup write_file
    au!
    au BufWritePre * call <SID>StripTrailingWhitespaces()
    " If git-tags is in $PATH run it on every save
    au BufWritePost * if executable('git-tags') | call system('"git-tags" &') | endif

augroup END

augroup filetypes
    au!
    au FileType text,*markdown* setlocal textwidth=72
    au FileType text,*markdown* setlocal formatoptions+=t
    au FileType text,*markdown* setlocal formatprg=par\ -72

    au FileType sh setlocal tabstop=4 noexpandtab

    au FileType mako,html,css,htmldjango,htmljinja EmmetInstall

    au FileType css,html,htmljinja,*javascript* setlocal shiftwidth=2
    au FileType css,html,htmljinja,*javascript* setlocal softtabstop=2
    au FileType htmljinja setlocal commentstring={#\ %s\ #}
    au FileType c setlocal formatprg=astyle\ -S
augroup END

" colorscheme 256_noir
colorscheme off
set background=dark

" tmux doesn't render italics properly, so let's just remap to standout
" if &term == "screen-256color"
"     highlight htmlItalic cterm=standout
" endif

function! <SID>StripTrailingWhitespaces()
    if !&binary && &filetype != 'diff'
        " prep: save last search, and cursor position.
        let _s=@/
        let l = line(".")
        let c = col(".")
        " Do the business:
        %s/\s\+$//ge
        " Clean up: restore previous search history, and cursor position
        let @/=_s
        call cursor(l, c)
    endif
endfunction

if g:colors_name == '256_noir'
    hi Search ctermfg=7 ctermbg=0 cterm=reverse
    hi IncSearch ctermfg=7 ctermbg=0
    hi Search ctermfg=7 ctermbg=0 cterm=reverse
    hi SignColumn ctermbg=none
endif

if g:colors_name == 'ron'
    hi ColorColumn ctermbg=8
    hi Comment ctermfg=8
    hi LineNr ctermfg=8
    hi SpellBad ctermfg=15
    hi SpellCap ctermfg=15
    hi TODO ctermfg=15 ctermbg=1
    hi link pythonOperator Statement
    hi link pythonNumber Structure
    hi link CtrlPMode2 StatusLine
    hi StatusLineNC ctermfg=8
    hi SignColumn ctermbg=none
endif
