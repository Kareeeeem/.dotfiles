call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'neomake/neomake'
Plug 'robertmeta/nofrils'
Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --all'}
Plug 'junegunn/fzf.vim'
Plug 'mbbill/undotree', {'on': 'UndotreeToggle'}
Plug 'moll/vim-bbye', {'on': 'Bdelete'}
Plug 'christoomey/vim-tmux-navigator', {'on': [
            \ 'TmuxNavigateLeft',
            \ 'TmuxNavigateRight',
            \ 'TmuxNavigateDown',
            \ 'TmuxNavigateUp',
            \ 'TmuxNavigatePrevious']}
Plug 'jpalardy/vim-slime' , {'on': [
            \ '<Plug>SlimeConfig',
            \ '<Plug>SlimeParagraphSend',
            \ '<Plug>SlimeRegionSend']}

" language help
Plug 'mattn/emmet-vim', {'for': ['html', 'css', 'htmldjango', 'htmljinja']}
Plug '2072/PHP-Indenting-for-VIm', {'for': 'php'}
Plug 'hynek/vim-python-pep8-indent', {'for': 'python'}
Plug 'Kareeeeem/python-docstring-comments', {'for': 'python'}
Plug 'pangloss/vim-javascript', {'for': ['javascript.jsx', 'javascript']}
" Plug 'mxw/vim-jsx', {'for': ['javascript.jsx', 'javascript']}

" See lazyload_editorconfig autocmd for lazy loading strat.
Plug 'editorconfig/editorconfig-vim' , {'on': []}

" Force myself to work with less buffers open
" Plug 'ap/vim-buftabline'

call plug#end()

filetype plugin indent on
syntax on

set autoindent
set background=dark
set backspace=2
set colorcolumn=80
set encoding=utf-8
set formatoptions=jcrq
set hidden
set hlsearch
set ignorecase
set smartcase
set incsearch
set nowrap
set number
set scrolloff=3

if has('signcolumn')
    set signcolumn=yes
else
    " http://superuser.com/a/558885
    augroup signs
        au!
        au BufEnter * sign define dummy
        au BufEnter * execute 'sign place 9999 line=1 name=dummy buffer=' . bufnr('')
    augroup END
endif

set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set dir=~/.vim/tmp
set tags=./tags,.git/tags
set undodir=~/.vim/undodir/
set undofile

" statusline
set laststatus=2
set statusline=%n\ %.50F\ %y
set statusline+=\ %h%m%r
set statusline+=%= " right alignment from this point
set statusline+=%-10.(%l,%c%V%)\ %P
set statusline+=\ %-4#Error#%{neomake#statusline#LoclistStatus('loc\ ')}%*


if executable("ag")
    set grepprg=ag\ --nogroup\ --nocolor\ --vimgrep
    set grepformat=%f:%l:%c:%m
endif

" Expand `%%` to current directory.
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" Because backslash is in a awkward place.
let mapleader = "\<Space>"

" I almost never want to go to the ABSOLUTE beginning of a line
nnoremap 0 ^

" break lines on a comma
nnoremap <leader>, f,cw,<CR><ESC>

nnoremap <Leader><Leader> :up<cr>

" Break line
nnoremap K i<cr><esc>kg$

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

nnoremap <left> :bp<cr>
nnoremap <right> :bn<cr>
nnoremap <leader>b :ls<cr>:b<space>

" Tmux navigator
nnoremap <silent> <c-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <c-j> :TmuxNavigateDown<cr>
nnoremap <silent> <c-k> :TmuxNavigateUp<cr>
nnoremap <silent> <c-l> :TmuxNavigateRight<cr>

" vim bbye
nnoremap <leader>q :Bdelete<cr>

" fzf
nnoremap <C-p> :Files<CR>
nnoremap <leader>t :Tags<CR>
nnoremap <leader>m :History<CR>
" nnoremap <leader>b :Buffers<cr>

" Slime
let g:slime_target = 'tmux'
let g:slime_python_ipython = 1
let g:slime_no_mappings = 1

let socketname = $debian_chroot != "" ? $debian_chroot : "default"
let g:slime_default_config = {"socket_name": socketname, "target_pane": ".1"}
" let g:slime_dont_ask_default = 1
xmap <leader>s <Plug>SlimeRegionSend
nmap <leader>s <Plug>SlimeParagraphSend
nmap <leader>v <Plug>SlimeConfig

" Neomake
let g:neomake_error_sign = {'text': 'E>', 'texthl': 'ErrorMsg'}
let g:neomake_warning_sign = {'text': 'W>', 'texthl': 'WarningMsg'}
let g:neomake_message_sign = {'text': 'M>', 'texthl': 'StatusLine'}
let g:neomake_info_sign = {'text': 'I>', 'texthl': 'StatusLine'}
let g:neomake_remove_invalid_entries = 1

let g:neomake_javascript_enabled_makers = ['eslint_d']

let g:neomake_c_enabled_makers = ['clang']
let g:neomake_c_clang_args = ['-fsyntax-only', '-std=c99', '-Weverything']

let g:neomake_python_enabled_makers = ['flake8']
let g:neomake_python_flake8_args = ['--max-line-length=100']

" Emmet
let g:user_emmet_install_global = 0

" vim-jsx
" let g:jsx_ext_required = 0

" Undotree
nnoremap <F5> :UndotreeToggle<CR>
if !exists('g:undotree_SplitWidth')
    let g:undotree_SplitWidth = 30
endif

" buftabline
" let g:buftabline_numbers=1
" let g:buftabline_indicators=1
" let g:buftabline_numbers=1

" Only register these autocommands if the necessary executables are present
if executable('ctags') && executable('git-tags')
    augroup tags
        au BufWritePost *.py,*.c call system('git-tags')
        au BufWritePost *.js call system("git-tags && clean_js_tags")
    augroup END
endif

augroup cleanup
    au!
    " strip trailing whitespace.
    let blacklist = ['markdown', 'text']
    au BufWritePre * if index(blacklist, &ft) < 0 | call Preserve('%s/\s\+$//ge') | endif

    " strip trailing white lines.
    au BufWritePre * call Preserve('v/\n*./d')
    au BufWritePost * Neomake
augroup END

augroup close
    au!
    " autoclose loclist/qflist if it is the last window.
    au BufEnter * if &buftype=="quickfix" && winnr('$') < 2 | quit! | endif
augroup END

augroup languages
    au!
    " au BufWritePre *.go call Preserve('%!gofmt 2> /dev/null')
    au FileType go setlocal formatprg=gofmt noexpandtab

    au FileType *markdown*,text setlocal formatoptions+=t formatprg=par\ -72 textwidth=72

    au FileType sh setlocal noexpandtab

    " I don't do c++ so always assume c
    au BufRead,BufNewFile *.h,*.c setlocal filetype=c
    au FileType c setlocal commentstring=//\ %s
    au FileType c setlocal cinoptions+=:0 " Don't indent case

    au FileType htmljinja,htmldjango setlocal commentstring={#\ %s\ #}
    au FileType mako,html,css,htmldjango,htmljinja EmmetInstall
augroup END

augroup qf
    au!
    au FileType qf setlocal nobuflisted
augroup END

" colorscheme
augroup colors
    au!
    hi link NeomakeError SpellBad
    hi link NeomakeWarning SpellCap
augroup END
colorscheme nofrils-dark

" editorconfig
augroup lazyload_editorconfig
    au!
    au SourcePre * if filereadable('.editorconfig')
                \ | call plug#load('editorconfig-vim')
                \ | endif
                \ | au! lazyload_editorconfig
augroup END

" http://stackoverflow.com/a/7086709
" call a command and restore view and registers.
function! Preserve(command)
    let w = winsaveview()
    execute a:command
    call winrestview(w)
endfunction
