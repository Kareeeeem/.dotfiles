" General settings {{{

filetype plugin indent on
syntax on

set completeopt+=longest
set completeopt-=preview
set autoindent
set backspace=2
set colorcolumn=80
set encoding=utf-8
set formatoptions=jcrq
set hidden
set nowrap
set scrolloff=3
set pastetoggle=<F6>
set number " relativenumber
set cursorline

set hlsearch ignorecase smartcase incsearch
set expandtab tabstop=4 softtabstop=4 shiftwidth=4

set dir=~/.vim/tmp
set tags=.git/tags
set undofile undodir=~/.vim/undodir/

if has('signcolumn')
    set signcolumn=yes
    augroup! signs " see autocommands
endif

if executable("ag")
    set grepprg=ag\ --nogroup\ --nocolor\ --vimgrep
    set grepformat=%f:%l:%c:%m
endif

" }}}

" Statusline {{{

set laststatus=2             " always show
set statusline=%n            " buffer number
set statusline+=\ %.50f      " file path
set statusline+=\ %Y         " file path
set statusline+=\ %H%M%R     " help / modified / readonly flags
set statusline+=%=           " right alignment from this point
set statusline+=%l,%c%V      " linenr,columnnr,percentage into file
set statusline+=\ %P         " percentage into file

" }}}

" Mappings {{{

" Expand `%%` to current directory.
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" cycle through completions with tab
" |i_CTRL-G_u| CTRL-G u start new undoable edit
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<C-g>u\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<C-g>u\<S-Tab>"

" Because backslash is in a awkward place.
let mapleader = "\<Space>"

" I almost never want to go to the ABSOLUTE beginning of a line
nnoremap 0 ^

" break lines on a comma's, parens, brackets, braces.
nnoremap <leader>, f,<right>i<cr><ESC>
nnoremap <leader>9 f(<right>i<cr><ESC>
nnoremap <leader>0 f)<cr><ESC>
nnoremap <leader>[ f[<right>i<cr><ESC>
nnoremap <leader>] f]i<cr><ESC>
nnoremap <leader>{ f{<right>i<cr><ESC>
nnoremap <leader>} f{i<cr><ESC>
" Break line
nnoremap K i<cr><esc>kg$

" write if changed
nnoremap <Leader><Leader> :up<cr>

" show manpage
nnoremap M K

" Toggle search highlighting
nnoremap <BS> :nohl<cr>

" Toggle relative numbers
nnoremap <F7> :set relativenumber!<cr>

" j and k on columns rather than lines
nnoremap j gj
nnoremap k gk

" Make Y consistent with C and D
nnoremap Y y$

" Highlight last inserted text
nnoremap gV `[v`]

" keep the visual selection after changing indentation
xnoremap < <gv
xnoremap > >gv

" Navigate buffers
nnoremap <S-Tab> :bp<cr>
nnoremap <Tab> :bn<cr>
nnoremap <leader>b :ls<cr>:b<space>

" }}}

" Plugins {{{

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
Plug 'davidhalter/jedi-vim', {'for': 'python'}
Plug 'pangloss/vim-javascript', {'for': 'javascript'}

Plug 'editorconfig/editorconfig-vim'
" Only load if there's an editorconfig file in the current folder.
if !filereadable('.editorconfig') | let g:loaded_EditorConfig = 1 | endif

call plug#end()

" nofrils
augroup nofrils
    au! nofrils ColorScheme nofrils-* call ModifyNofrils()
augroup END

function! ModifyNofrils()
    hi clear CursorLineNr
    hi link CursorLineNr Normal
    hi TODO cterm=bold

    hi Repeat cterm=bold
    hi Conditional cterm=bold
    hi Statement cterm=bold
    hi Exception cterm=bold
    " hi Type cterm=bold
endfunction

" Tmux navigator
nnoremap <silent> <c-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <c-j> :TmuxNavigateDown<cr>
nnoremap <silent> <c-k> :TmuxNavigateUp<cr>
nnoremap <silent> <c-l> :TmuxNavigateRight<cr>

" vim bbye
nnoremap <leader>q :Bdelete<cr>

" fzf
nnoremap <C-p> :Files<cr>
nnoremap <leader>t :Tags<cr>
nnoremap <leader>m :History<cr>
" nnoremap <leader>b :Buffers<cr>

" jedi
" https://github.com/davidhalter/jedi-vim/issues/651
" let g:jedi#show_call_signatures = 0
let g:jedi#auto_vim_configuration = 0
let g:jedi#smart_auto_mappings = 0
let g:jedi#popup_on_dot = 0 " so slow
let g:jedi#documentation_command = "M"
" let g:jedi#show_call_signatures = 0
" let g:jedi#completions_enabled = 0

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
let g:neomake_error_sign = {'text': 'E', 'texthl': 'ErrorMsg'}
let g:neomake_warning_sign = {'text': 'W', 'texthl': 'WarningMsg'}
let g:neomake_message_sign = {'text': 'M', 'texthl': 'StatusLine'}
let g:neomake_info_sign = {'text': 'I', 'texthl': 'StatusLine'}
let g:neomake_remove_invalid_entries = 1

let g:neomake_javascript_enabled_makers = ['eslint_d']

let g:neomake_c_enabled_makers = ['clang']
let g:neomake_c_clang_args = ['-fsyntax-only', '-std=c99', '-Weverything']

let g:neomake_python_enabled_makers = ['flake8']
let g:neomake_python_flake8_args = ['--max-line-length=100']

set statusline+=\ %#Error#%{neomake#statusline#LoclistStatus('loc\ ')}%*

augroup neo_make
    au!
    au BufWritePost * Neomake
    au ColorScheme * hi link NeomakeError SpellBad
    au ColorScheme * hi link NeomakeWarning SpellCap
augroup END

" Emmet
let g:user_emmet_install_global = 0
augroup emmet
    au!
    au FileType mako,html,css,htmldjango,htmljinja EmmetInstall
augroup END

" Undotree
nnoremap <F5> :UndotreeToggle<cr>
let g:undotree_SetFocusWhenToggle = 1

" }}}

" Autocommands {{{

augroup signs " http://superuser.com/a/558885
    au!
    au BufEnter * sign define dummy
    au BufEnter * execute 'sign place 9999 line=1 name=dummy buffer=' . bufnr('')
augroup END

" Only register these autocommands if the necessary executables are present
if executable('ctags') && executable('git-tags')
    augroup tags
        au!
        au BufWritePost *.py,*.c call system('git-tags')
        au BufWritePost *.js call system("git-tags && clean_js_tags")
    augroup END
endif

let ws_blacklist = ['markdown', 'text']
augroup cleanup_ws
    au!
    " strip trailing whitespace.
    au BufWritePre * if index(ws_blacklist, &ft) < 0
                \ | call Preserve('%s/\s\+$//ge')
                \ | endif

    " strip trailing white lines.
    au BufWritePre * call Preserve('v/\n*./d')
augroup END

augroup languages
    au!
    au FileType *markdown*,text setlocal fo+=t fp=par\ -72 tw=72

    au FileType sh setlocal noexpandtab

    au FileType python setlocal keywordprg=pydoc

    " I don't do c++ so always assume c
    au BufRead,BufNewFile *.h,*.c setlocal filetype=c
    au FileType c setlocal commentstring=//\ %s
    au FileType c setlocal cinoptions+=:0 " Don't indent case

    au FileType htmljinja,htmldjango setlocal commentstring={#\ %s\ #}

    au BufReadPre *vimrc setlocal foldenable foldmethod=marker
augroup END

augroup qf
    au!
    au FileType qf setlocal nobuflisted
    " autoclose loclist/qflist if it is the last window.
    au BufEnter * if &buftype=="quickfix" && winnr('$') < 2 | quit! | endif
augroup END

" }}}

" Colorscheme {{{

" set the colorscheme last to allow any ColorScheme autocmds to get set.
colorscheme nofrils-dark

" }}}

" Functions {{{

" http://stackoverflow.com/a/7086709
" call a command and restore view and registers.
function! Preserve(command)
    let w = winsaveview()
    execute a:command
    call winrestview(w)
endfunction

" }}}
