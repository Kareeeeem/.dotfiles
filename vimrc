syntax on

call plug#begin('~/.vim/plugged')

Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --all'}
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'scrooloose/syntastic'
Plug 'ap/vim-buftabline'
Plug 'jpalardy/vim-slime'
Plug 'Kareeeeem/vim-walou'
Plug 'christoomey/vim-tmux-navigator'
Plug 'mattn/emmet-vim', {'for': ['html', 'css', 'htmldjango', 'htmljinja']}
Plug 'mitsuhiko/vim-jinja', {'for': ['html', 'htmldjango', 'htmljinja']}
Plug 'hynek/vim-python-pep8-indent', {'for': 'python'}
Plug 'pangloss/vim-javascript', {'branch': 'develop', 'for': ['javascript.jsx', 'javascript']}
Plug 'mxw/vim-jsx', {'for': ['javascript.jsx', 'javascript']}
Plug 'mbbill/undotree', {'on': 'UndotreeToggle'}

call plug#end()

filetype plugin indent on

set autoindent
set background=dark
set backspace=2
set colorcolumn=80
set dir=~/.vim/tmp
set encoding=utf-8
set expandtab
set formatoptions=jcroq
set hidden
set hlsearch
set ignorecase
set incsearch
set nofoldenable
set nowrap
set number
set scrolloff=3
set shiftwidth=4
set smartcase
set softtabstop=4
set tags=./tags,.git/tags
set undodir=~/.vim/undodir/
set undofile

" colorscheme
" colorscheme walou
colorscheme ron

hi ColorColumn ctermbg=8
hi Comment ctermfg=8
hi LineNr ctermfg=8
hi SpellBad ctermfg=15
hi SpellCap ctermfg=15
hi TODO ctermfg=15 ctermbg=1
hi link pythonOperator Statement
hi link pythonNumber Structure
hi StatusLineNC ctermfg=8
hi SignColumn ctermbg=none

" statusline
set laststatus=2
set statusline=%n\ %.20F\ %y
set statusline+=\ %h%m%r
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
" break lines on a comma
nnoremap <leader>, f,cw,<CR><ESC>
" Go to last used buffer
nnoremap <Leader><Leader> <C-^>
" Break line
nnoremap K i<cr><esc>k$
" Toggle search highlighting
nnoremap <leader>h :set hlsearch!<CR>
" Toggle paste
nnoremap <leader>p :set paste!<CR>
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

" nnoremap <C-h> <C-w>h
" nnoremap <C-j> <C-w>j
" nnoremap <C-k> <C-w>k
" nnoremap <C-l> <C-w>l

nnoremap <leader>b :ls<cr>:b<space>

nnoremap <leader>gq gqip

" move through completion menu with tab
inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" select completion candidate with enter
inoremap <silent><expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

nnoremap <left> :bp<cr>
nnoremap <right> :bn<cr>

nnoremap <leader>lp :lprev<cr>
nnoremap <leader>ln :lnext<cr>
nnoremap <leader>ll :ll<cr>

nnoremap <leader>d<space> c3l=<esc>
nnoremap <leader>i<space> cw<space>=<space><esc>

" fzf
nnoremap <C-p> :Files<CR>
nnoremap <leader>t :Tags<CR>
nnoremap <leader>m :History<CR>
" let g:fzf_layout = { 'right': '60%' }

" Slime
let g:slime_target = 'tmux'
let g:slime_python_ipython = 1

" Syntastic
let g:syntastic_c_compiler='clang'
let g:syntastic_c_compiler_options='-std=c99 -Weverything'

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

" vim-jsx
let g:jsx_ext_required = 0

" Undotree
nnoremap <F5> :UndotreeToggle<CR>
if !exists('g:undotree_SplitWidth')
    let g:undotree_SplitWidth = 30
endif

" buftabline
let g:buftabline_numbers=1
let g:buftabline_indicators=1
let g:buftabline_numbers=1

" This keeps the sign column visible at all times. Can't stand the
" twitching when linting for errors. http://superuser.com/a/558885
" augroup dummysign
"     au!
"     au BufEnter * sign define dummy
"     au BufEnter * execute 'sign place 9999 line=1 name=dummy buffer=' . bufnr('')
" augroup END

augroup write_file
    au!
    " strip all trailing whitespace
    au BufWritePre * call Preserve('%s/\s\+$//ge')
    au BufWritePost * if executable('git-tags') | call system('"git-tags" &') | endif
augroup END

augroup go
    au!
    " au BufWritePre *.go call Preserve('%!gofmt 2> /dev/null')
    au FileType go setlocal formatprg=gofmt noexpandtab tabstop=4
augroup END

augroup md
    au!
    au FileType *markdown* setlocal formatoptions+=t
    au FileType *markdown* setlocal formatprg=par\ -72
    au FileType *markdown* setlocal textwidth=72
    au FileType *markdown* setlocal textwidth=72
    au FileType *markdown* nnoremap <leader>snl :set spell spelllang=nl<cr>
    au FileType *markdown* nnoremap <leader>ss :set nospell<cr>
augroup END

augroup txt
    au!
    au FileType text setlocal wrap linebreak nolist
augroup END

augroup shell
    au!
    au FileType sh setlocal tabstop=4 noexpandtab
augroup END

augroup c
    au!
    au FileType c setlocal commentstring=//\ %s
    " Don't indent case
    au FileType c setlocal cinoptions+=:0

    " au FileType c setlocal cindent shiftwidth=8 noexpandtab
augroup END

augroup frontend
    au!
    au FileType css,html,htmljinja,*javascript* setlocal shiftwidth=2 softtabstop=2
    au FileType css,html,htmljinja,*javascript* setlocal softtabstop=2
    au FileType htmljinja setlocal commentstring={#\ %s\ #}
    au FileType mako,html,css,htmldjango,htmljinja EmmetInstall
    au FileType *javascript* nnoremap <silent> <leader>r :call system('tmux send-keys -t :.1 c-c c-m "npm start" c-m')<cr>
augroup END

" http://stackoverflow.com/a/7086709
" call a command and restore view. Also resets the registers.
function! Preserve(command)
    let w = winsaveview()
    execute a:command
    call winrestview(w)
endfunction
