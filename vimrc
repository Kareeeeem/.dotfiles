" General settings {{{

filetype plugin indent on
syntax on

set wildmenu
set showcmd

set ttimeout        " time out for key codes
set ttimeoutlen=100 " wait up to 100ms after Esc for special key

set completeopt-=preview
" set complete-=t
set autoindent
set backspace=2
set colorcolumn=80
set encoding=utf-8
set fileencoding=utf-8
set formatoptions=tjrocqn
set hidden
set nowrap
set scrolloff=3
set pastetoggle=<F6>
set number

set hlsearch ignorecase smartcase incsearch
set expandtab tabstop=4 softtabstop=4 shiftwidth=4

set dir=$HOME/.vim/tmp
set tags=.git/tags,./tags
set undofile undodir=$HOME/.vim/undodir/

if exists("&signcolumn")
    set signcolumn=yes
else
    augroup signs
        au!
        au BufEnter * call SetSigncolumn()
    augroup END
endif

if executable("rg")
    set grepprg=rg\ --vimgrep\ --no-heading
    set grepformat=%f:%l:%c:%m,%f:%l:%m
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

" Because backslash is in a awkward place.
let mapleader = "\<Space>"

" I almost never want to go to the ABSOLUTE beginning of a line
nnoremap 0 ^

" break lines on a comma's, parens, brackets, braces.
nnoremap <leader>, f,<right>i<cr><ESC>
" Break line
nnoremap K i<cr><esc>kg$
" show manpage
nnoremap M K
" Original J on leader j
nnoremap <leader>j J
" Join lines without whitespace
nnoremap <silent> J :call JoinSpaceless()<cr>
" Toggle search highlighting
nnoremap <BS> :nohl<cr>
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

" Don't use Ex mode.
map Q <nop>

" }}}

" Plugins {{{

call plug#begin('~/.vim/plugged')

Plug 'keith/tmux.vim'
Plug 'ap/vim-buftabline'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'neomake/neomake'
Plug 'robertmeta/nofrils'
Plug 'jpalardy/vim-slime'
Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --all'}
Plug 'junegunn/fzf.vim'
Plug 'mbbill/undotree', {'on': 'UndotreeToggle'}
Plug 'moll/vim-bbye', {'on': 'Bdelete'}
Plug 'christoomey/vim-tmux-navigator',
            \ {'on': [
            \ 'TmuxNavigateLeft',
            \ 'TmuxNavigateRight',
            \ 'TmuxNavigateDown',
            \ 'TmuxNavigateUp',
            \ 'TmuxNavigatePrevious']}

" language help
Plug 'mattn/emmet-vim'
Plug 'hynek/vim-python-pep8-indent'
Plug 'Kareeeeem/python-docstring-comments'
Plug 'pangloss/vim-javascript'
Plug 'wlangstroth/vim-racket'

call plug#end()

"buftabline
let g:buftabline_numbers = 1
let g:buftabline_indicators = 1

" Tmux navigator
nnoremap <silent> <c-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <c-j> :TmuxNavigateDown<cr>
nnoremap <silent> <c-k> :TmuxNavigateUp<cr>
nnoremap <silent> <c-l> :TmuxNavigateRight<cr>
let g:tmux_navigator_disable_when_zoomed=1

" vim bbye
nnoremap <leader>q :Bdelete<cr>

" fzf
nnoremap <C-p> :Files<cr>
nnoremap <leader>t :Tags<cr>
nnoremap <leader>m :History<cr>
nnoremap <leader>b :Buffers<cr>
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

" Slime
let g:slime_target = 'tmux'
let g:slime_python_ipython = 1
let g:slime_no_mappings = 1

xmap <leader>s <Plug>SlimeRegionSend
nmap <leader>s <Plug>SlimeParagraphSend
nmap <leader>v <Plug>SlimeConfig

" Neomake
let g:neomake_error_sign = {'text': 'E', 'texthl': 'ErrorMsg'}
let g:neomake_warning_sign = {'text': 'W', 'texthl': 'WarningMsg'}
let g:neomake_message_sign = {'text': 'M', 'texthl': 'StatusLine'}
let g:neomake_info_sign = {'text': 'I', 'texthl': 'StatusLine'}

let g:neomake_remove_invalid_entries=1

let g:neomake_c_enabled_makers = ['clang']
let g:neomake_c_clang_args = ['-fsyntax-only', '-std=c99', '-Weverything', '-I./']
" for some reason this global option is not respected so define it here again
let g:neomake_c_clang_remove_invalid_entries=1

let g:neomake_python_enabled_makers = ['flake8']
let g:neomake_python_flake8_args = ['--max-line-length=100']

let g:neomake_sh_shellcheck_args = ['-fgcc', '-s', 'bash', '-e', 'SC1090,SC1091']

let g:neomake_racket_raco_maker = {
            \ 'exe': 'raco',
            \ 'args': ['expand'],
            \ 'errorformat': '%-G %.%#,%E%f:%l:%c: %m'
            \ }
let g:neomake_racket_enabled_makers = ['raco']

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

augroup vimStartup
    au!
    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    autocmd BufReadPost *
                \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft != 'gitcommit'
                \ | exe "normal! g`\""
                \ | endif
augroup END

" Only register these autocommands if the necessary executables are present
if executable('ctags') && executable('git-tags')
    augroup tags
        au!
        au BufWritePost *.py,*.c call system('git-tags &')
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
    au BufWritePre *.go call Preserve('%!gofmt')

    au FileType *markdown*,text setlocal fo+=t tw=72 wrap fp=par\ -w72
    " au FileType sh setlocal noexpandtab
    "
    au FileType python setlocal keywordprg=pydoc
    au FileType python inoremap pdb import pdb; pdb.set_trace()<esc>

    au BufReadPre *vimrc setlocal foldenable foldmethod=marker

    " I don't do c++ so always assume c
    au BufRead,BufNewFile *.h,*.c setlocal filetype=c
    au FileType c setlocal commentstring=//\ %s
    au FileType c setlocal cinoptions+=:0 " Don't indent case
    au FileType awk setlocal commentstring=#\ %s
    au FileType htmljinja,htmldjango setlocal commentstring={#\ %s\ #}
    au FileType php setlocal commentstring=//\ %s
    au FileType racket,scheme setlocal commentstring=;\ %s
    au FileType xdefaults setlocal commentstring=!\ %s
    au FileType rc setlocal commentstring=#\ %s

    au FileType yaml setlocal tabstop=2 softtabstop=2 shiftwidth=2
augroup END

augroup qf
    au!
    au FileType qf setlocal nobuflisted
    " autoclose loclist/qflist if it is the last window.
    au BufEnter * if &buftype=="quickfix" && winnr('$') < 2 | quit! | endif
augroup END

" }}}

" Colorscheme {{{

augroup nofrils
    au!
    au ColorScheme nofrils* call ModifyNofrils()
    au ColorScheme nofrils* nnoremap <F7> :call ToggleNofrils()<cr>
augroup END

function! ModifyNofrils()
    hi clear CursorLineNr
    hi link CursorLineNr Normal
    hi TODO cterm=bold
    hi Repeat cterm=bold
    hi Conditional cterm=bold
    hi Statement cterm=bold
    hi Exception cterm=bold
    hi Comment ctermfg=244
endfunction

" set the colorscheme last to allow any ColorScheme autocmds to get set.
colorscheme nofrils-dark

" }}}

" Functions and Commands {{{

" http://stackoverflow.com/a/7086709
" call a command and restore view.
function! Preserve(command)
    let w = winsaveview()
    silent execute a:command
    call winrestview(w)
endfunction

if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | file diffscratch | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
  command DiffClose diffoff! | bd diffscratch
endif

" http://superuser.com/a/558885
function! SetSigncolumn()
    sign define dummy
    execute 'sign place 9999 line=1 name=dummy buffer=' . bufnr('')
endfunction

" http://vi.stackexchange.com/a/440
" Like gJ, but always remove spaces
function! JoinSpaceless()
    execute 'normal gJ'
    " Character under cursor is whitespace remove it.
    if matchstr(getline('.'), '\%' . col('.') . 'c.') =~ '\s'
        execute 'normal dw'
    endif
endfunction

function! ToggleNofrils()
    if (g:colors_name == 'nofrils-dark')
        colorscheme nofrils-light
    elseif (g:colors_name == 'nofrils-light')
        colorscheme nofrils-dark
    endif
endfunction


" }}}
