call plug#begin('~/.config/nvim/plugged')

Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --all'}
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'ap/vim-buftabline'
Plug 'itchyny/vim-gitbranch'
" Plug 'Shougo/deoplete.nvim'
Plug 'benekastah/neomake'
Plug 'jpalardy/vim-slime'
Plug 'christoomey/vim-tmux-navigator'
Plug 'mbbill/undotree', {'on': 'UndotreeToggle'}
Plug 'davidhalter/jedi-vim', {'for': 'python'}
" Plug 'zchee/deoplete-jedi', {'for': 'python'}
Plug 'hynek/vim-python-pep8-indent', {'for': 'python'}
Plug 'mitsuhiko/vim-jinja', {'for': ['html', 'htmldjango', 'htmljinja']}
Plug 'mattn/emmet-vim', {'for': ['html', 'css', 'htmldjango', 'htmljinja']}
Plug 'pangloss/vim-javascript', {'for': ['javascript.jsx', 'javascript']}
Plug 'mxw/vim-jsx', {'for': ['javascript.jsx', 'javascript']}
Plug 'janko-m/vim-test', {'on': ['TestNearest', 'TestFile', 'TestSuite', 'TestLast', 'TestVisit']}
Plug 'andreasvc/vim-256noir'

call plug#end()

set colorcolumn=80
set dir=~/.config/nvim/tmp
set expandtab
set formatoptions+=r
set hidden
set ignorecase
set mouse=
set nofoldenable
set nowrap
set number
set scrolloff=3
set shiftwidth=4
set smartcase
set softtabstop=4
set tags=.git/tags
set undodir=~/.config/nvim/undodir/
set undofile

set statusline=%n\ %.20F\ %y
set statusline+=\ %h%m%r
set statusline+=%{gitbranch#name()}
set statusline+=%= " right alignment from this point
set statusline+=%-14.(%l,%c%V%)\ %P
set statusline+=\ %#Error#%{neomake#statusline#LoclistStatus()}%*
set statusline+=\ %#Error#%{neomake#statusline#QflistStatus()}%*

" Expand `%%` to current directory.
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" Because backslash is in a awkward place.
let mapleader = "\<Space>"

" I almost never want to go to the ABSOLUTE beginning of a line
nnoremap 0 ^

" Insert a uuid
" nnoremap <leader>u '<C-r>=system('python -c "import uuid, sys; sys.stdout.write(str(uuid.uuid4()))"')<CR>'
" Insert the current date formatted like Fri 15-01-2016 20:06
" nnoremap <leader>d <C-r>=substitute(system('echo $(date +"%a %d-%m-%Y %H:%M")'), '[\r\n]*$','','')<CR>

" Break lines on a comma.
nnoremap <leader>, f,cw,<CR><ESC>

nnoremap <leader>ln :lnext<cr>
nnoremap <leader>lp :lprev<cr>

" Go to last used buffer
nnoremap <Leader><Leader> <C-^>

" Break line
nnoremap K i<cr><esc>k$

" Toggle search highlighting
nnoremap <F7> :set hlsearch!<CR>

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

" for python plugins
let g:python_host_prog = '/home/kareem/.py2neovim/bin/python'
let g:python3_host_prog = '/home/kareem/.py3neovim/bin/python'

" vim test
let test#strategy = "neovim"

" neomake
let g:neomake_error_sign = { 'text': '>>', 'texthl': 'ErrorMsg' }
let g:neomake_warning_sign = { 'text': '>>', 'texthl': 'WarningMsg' }

" fzf
nnoremap <C-p> :Files<CR>
nnoremap <leader>t :Tags<CR>
nnoremap <leader>m :History<CR>

" deoplete
" let g:deoplete#enable_at_startup = 1
" let g:deoplete#sources = {}
" let g:deoplete#sources.python = ['buffer', 'tag']
" inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" jedi
" let g:jedi#smart_auto_mappings=0
" let g:jedi#documentation_command='D'
" let g:jedi#show_call_signatures=0
" let g:jedi#popup_select_first=0

" Emmet
let g:user_emmet_install_global = 0

" Undotree
nnoremap <F5> :UndotreeToggle<CR>
if !exists('g:undotree_SplitWidth')
    let g:undotree_SplitWidth = 30
endif

" vim-jsx
let g:jsx_ext_required = 0

" Buftabline
let g:buftabline_numbers = 1
let g:buftabline_indicators = 1
let g:buftabline_seperators = 1

" This keeps the sign column visible at all times. Can't stand the
" twitching when linting for errors. http://superuser.com/a/558885
augroup dummysign
    au!
    autocmd BufEnter * sign define dummy
    autocmd BufEnter * execute 'sign place 9999 line=1 name=dummy buffer=' . bufnr('')
augroup END

augroup write_file
    au!
    au BufWritePost * Neomake
    au BufWritePre * call StripTrailingWhitespaces()
    au BufWritePost *.py call GenerateTags()
    au BufWritePost *.c call GenerateTags()
augroup END

augroup filetypes
    au!
    au FileType sh setlocal tabstop=4 noexpandtab

    au FileType text,*markdown* setlocal textwidth=72
    au FileType text,*markdown* setlocal formatoptions+=t
    au FileType text,*markdown* setlocal formatprg=par\ -72

    au FileType mako,html,css,htmldjango,htmljinja EmmetInstall

    au FileType css,html,htmljinja,*javascript* setlocal shiftwidth=2
    au FileType css,html,htmljinja,*javascript* setlocal softtabstop=2

    au FileType htmljinja setlocal commentstring={#\ %s\ #}

    au FileType c setlocal formatprg=astyle\ -S
augroup END

colorscheme 256_noir

" some customizations
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

function! GenerateTags()
    " if executable('git-tags') | call system('"git-tags" &') | endif
    if executable('git-tags') | call jobstart('git-tags') | endif
endfunction

function! StripTrailingWhitespaces()
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
