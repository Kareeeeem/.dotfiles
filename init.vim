call plug#begin('~/.config/nvim/plugged')

Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --all'}
Plug 'junegunn/fzf.vim'

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'ap/vim-buftabline'
Plug 'itchyny/vim-gitbranch'
Plug 'Shougo/deoplete.nvim'
Plug 'benekastah/neomake'
Plug 'christoomey/vim-tmux-navigator'

Plug 'mbbill/undotree', {'on': 'UndotreeToggle'}

Plug 'davidhalter/jedi-vim', {'for': 'python'}
Plug 'zchee/deoplete-jedi', {'for': 'python'}
Plug 'hynek/vim-python-pep8-indent', {'for': 'python'}
Plug 'mitsuhiko/vim-jinja', {'for': ['html', 'htmldjango', 'htmljinja']}

Plug 'mattn/emmet-vim', {'for': ['html', 'css', 'htmldjango', 'htmljinja']}

Plug 'pangloss/vim-javascript', {'for': ['javascript.jsx', 'javascript']}
Plug 'mxw/vim-jsx', {'for': ['javascript.jsx', 'javascript']}

call plug#end()

set colorcolumn=80
set completeopt+=noinsert,noselect
set dir=~/.config/nvim/tmp
set expandtab
set formatoptions+=r
set hidden
set ignorecase
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

" Expand `%%` to current directory.
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'
" Because backslash is in a awkward place.
let mapleader = "\<Space>"
" I almost never want to go to the ABSOLUTE beginning of a line
nnoremap 0 ^

" Insert a uuid
nnoremap <leader>u '<C-r>=system('python -c "import uuid, sys; sys.stdout.write(str(uuid.uuid4()))"')<CR>'
" Insert the current date formatted like Fri 15-01-2016 20:06
nnoremap <leader>d <C-r>=substitute(system('echo $(date +"%a %d-%m-%Y %H:%M")'), '[\r\n]*$','','')<CR>

" Break lines on a comma.
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

" neomake
let g:neomake_error_sign = {
            \ 'text': '>>',
            \ 'texthl': 'ErrorMsg',
            \ }

let g:neomake_warning_sign = {
            \ 'text': '>>',
            \ 'texthl': 'WarningMsg',
            \ }

" for python plugins
let g:python_host_prog = '/home/kareem/.py2neovim/bin/python'
let g:python3_host_prog = '/home/kareem/.py3neovim/bin/python'

" fzf
nnoremap <C-p> :Files<CR>
nnoremap <leader>t :Tags<CR>
nnoremap <leader>m :History<CR>

let g:deoplete#enable_at_startup = 1
let g:deoplete#sources = {}
let g:deoplete#sources._ = ['buffer']
let g:deoplete#sources.python = ['buffer', 'tag']
imap <silent><expr><Tab> pumvisible() ? "\<C-n>" : "<Tab>"
imap <silent><expr><S-Tab> pumvisible() ? "\<C-p>" : "<S-Tab>"

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

augroup write_file
    au!
    au BufWritePost * Neomake
    au BufWritePre * call StripTrailingWhitespaces()
    au BufWritePost *.py call GenerateTags()
    au BufWritePost *.c call GenerateTags()

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

if &term == "screen-256color"
    highlight htmlItalic cterm=standout
endif

colorscheme ron
" A little customization is in order.
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

function GenerateTags()
    if executable('git-tags') | call system('"git-tags" &') | endif
endfunction

function StripTrailingWhitespaces()
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
