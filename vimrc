" General settings

filetype plugin indent on
syntax on

set wildmenu
set showcmd

set updatetime=500
set breakindent
set completeopt-=preview
" set complete-=t
set autoindent
set backspace=2
set colorcolumn=121
set encoding=utf-8
set fileencoding=utf-8
set formatoptions=tjrocqn
set hidden
set nowrap
set scrolloff=3
set pastetoggle=<F6>
" set number
set nojoinspaces  " don't insert double spaces.

set hlsearch ignorecase smartcase incsearch
set expandtab tabstop=4 softtabstop=4 shiftwidth=4
set signcolumn=yes

set dir=$HOME/.vim/tmp
set tags=.git/tags,./tags,../tags
set undofile undodir=$HOME/.vim/undodir/

let c_no_curly_error = 1
let c_syntax_for_h = 1

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
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]
set statusline+=%=           " right alignment from this point
set statusline+=%l,%c%V      " linenr,columnnr,percentage into file
set statusline+=\ %P         " percentage into file


" Mappings

" Expand `%%` to current directory.
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'
" Because backslash is in a awkward place.
let mapleader = "\<Space>"
" I almost never want to go to the ABSOLUTE beginning of a line
nnoremap 0 ^
" break lines on a comma's
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
" nnoremap <leader>b :ls<cr>:b<space>

" Don't use Ex mode.
map Q <nop>


" Plugins

function! PlugLoaded(name)
    return (
        \ has_key(g:plugs, a:name) &&
        \ isdirectory(g:plugs[a:name].dir) &&
        \ stridx(&rtp, g:plugs[a:name].dir) >= 0)
endfunction

if empty(glob('~/.config/nvim/autoload/plug.vim'))
	silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
	    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.config/nvim/plugged')

" call plug#begin('~/.vim/plugged')

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
Plug 'christoomey/vim-tmux-navigator'
Plug 'python/black'

" language help
Plug 'mattn/emmet-vim'
Plug 'hynek/vim-python-pep8-indent'
Plug 'Kareeeeem/python-docstring-comments'
Plug 'pangloss/vim-javascript'
Plug 'wlangstroth/vim-racket'
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Plug 'neoclide/coc-python'
" Plug 'neoclide/coc-json'


call plug#end()

" COC Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

let g:coc_global_extensions=['coc-python']

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" augroup COC
"     au!
"     au CursorHold * :call CocAction('doHover')
" augroup END

"buftabline
let g:buftabline_numbers = 1
let g:buftabline_indicators = 1

" Tmux navigator
let g:tmux_navigator_disable_when_zoomed=1

" vim bbye
nnoremap <leader>q :Bdelete<cr>

" fzf
nnoremap <C-p> :Files<cr>
nnoremap <leader>t :Tags<cr>
nnoremap <leader>m :History<cr>
nnoremap <leader>b :Buffers<cr>

" Slime
let g:slime_target = 'tmux'
let g:slime_python_ipython = 1
let g:slime_no_mappings = 1

xmap <leader>s <Plug>SlimeRegionSend
nmap <leader>s <Plug>SlimeParagraphSend
nmap <leader>v <Plug>SlimeConfig

" black
let g:black_fast = 1
let g:black_skip_string_normalization = 1

" Neomake
let g:neomake_javascript_enabled_makers = ['eslint']

let g:neomake_error_sign = {'text': '>>', 'texthl': 'ErrorMsg'}
let g:neomake_warning_sign = {'text': '>>', 'texthl': 'WarningMsg'}
let g:neomake_message_sign = {'text': '>>', 'texthl': 'StatusLine'}
let g:neomake_info_sign = {'text': '>>', 'texthl': 'StatusLine'}

let g:neomake_place_signs = 1

let g:neomake_remove_invalid_entries=1

let g:neomake_c_enabled_makers = ['gcc']
let g:neomake_c_gcc_args = ['-fsyntax-only', '-Wall', '-Wextra', '-I./', '-fno-diagnostics-show-caret']
" for some reason this global option is not respected so define it here again
let g:neomake_c_gcc_remove_invalid_entries=1

" let g:neomake_c_clang_args = ['-fsyntax-only', '-std=c99', '-Weverything', '-I./']

let g:neomake_python_enabled_makers = ['flake8']
let g:neomake_python_flake8_args = ['--max-line-length=120']

let g:neomake_sh_shellcheck_args = ['-fgcc', '-s', 'bash', '-e', 'SC1090,SC1091']

let g:neomake_racket_enabled_makers = ['raco']
let g:neomake_racket_raco_remove_invalid_entries=1

if PlugLoaded('coc.nvim')
    set statusline+=\ %{coc#status()}
endif
if PlugLoaded('neomake')
    set statusline+=\ %#Error#%{neomake#statusline#LoclistStatus('loc\ ')}%*
endif

augroup neo_make
    au!
    au BufWritePost * Neomake
    " au ColorScheme * hi link NeomakeError SpellBad
    " au ColorScheme * hi link NeomakeWarning SpellCap
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


" Autocommands

augroup vimStartup
    au!
    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    au BufReadPost *
                \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft != 'gitcommit'
                \ | exe "normal! g`\""
                \ | endif
    au InsertLeave * if pumvisible() == 0 | pclose | endif
augroup END

" Only register these autocommands if the necessary executables are present
if executable('ctags') && executable('git-tags')
    augroup tags
        au!
        au BufWritePost *.py,*.c call system('git-tags &')
    augroup END
endif

let ws_blacklist = []
augroup cleanup_ws
    au!
    " strip trailing whitespace.
    au BufWritePre * if index(ws_blacklist, &ft) < 0
                \ | call Preserve('%s/\s\+$//ge')
                \ | endif
    " strip trailing white lines.
    au BufWritePre * call Preserve('v/\n*./d')
augroup END

" Work related autocommands
augroup softwear
    au!
    au BufWritePre $HOME/projects/softwear/**/*.py execute ':Black'
augroup END


augroup languages
    au!
    au BufWritePre *.go call Preserve('%!gofmt')

    " vim-racket overrides my K mapping
    au FileType racket nunmap <buffer> K

    au FileType *markdown*,text setlocal fo+=t tw=72 wrap
    " au FileType sh setlocal noexpandtab

    au FileType python setlocal keywordprg=pydoc
    au FileType python inoremap <buffer> pdb breakpoint()  # noqa<esc>

    " au FileType c setlocal commentstring=//\ %s
    " au FileType c setlocal cinoptions+=:0 " Don't indent case
    au FileType awk setlocal commentstring=#\ %s
    au FileType htmljinja,htmldjango setlocal commentstring={#\ %s\ #}
    au FileType php setlocal commentstring=//\ %s
    au FileType racket,scheme setlocal commentstring=;\ %s
    au FileType racket,scheme setlocal commentstring=;\ %s

    au FileType xdefaults setlocal commentstring=!\ %s
    au FileType rc setlocal commentstring=#\ %s

    au FileType yaml,ruby setlocal tabstop=2 softtabstop=2 shiftwidth=2

    au BufRead,BufNewFile *.zpl set filetype=zpl
    au FileType zpl setlocal commentstring=^FX\ %s
augroup END

augroup qf
    au!
    au FileType qf setlocal nobuflisted
    " autoclose loclist/qflist if it is the last window.
    au BufEnter * if &buftype=="quickfix" && winnr('$') < 2 | quit! | endif
augroup END


" Colorscheme

augroup nofrils
    au!
    au ColorScheme * call ModifyColorscheme()
    au ColorScheme nofrils* nnoremap <F7> :call ToggleNofrils()<cr>
augroup END

function! ModifyColorscheme()
    " Some modifications I like for nofrils-dark
    if (g:colors_name == "nofrils-dark")
        " brighten the comments
        hi Comment ctermfg=243
        " dim the normal text a little bit.
        hi Normal ctermfg=253 ctermbg=NONE

        hi TODO cterm=bold

        " Nofrils undoes all the links. I want to reestablish some of the
        " main ones to experiment with some minimal highlighting.

        " hi Statement ctermfg=11
        " hi link Conditional Statement
        " hi link Repeat Statement
        " hi link Label Statement
        " hi link Operator Statement
        " hi link Keyword Statement
        " hi link Exception Statement

        " hi PreProc ctermfg=81
        " hi link Include PreProc
        " hi link Define PreProc
        " hi link Macro PreProc
        " hi link PreCondit PreProc

        " hi Identifier ctermfg=14
        " hi link Function Identifier

        " hi Constant ctermbg=233
        " hi link String Constant
        " hi link Character Constant
        " hi link Number Constant
        " hi link Boolean Constant
        " hi link Float Constant


        if (&cursorline)
            hi clear CursorLineNr
            hi link CursorLineNr Normal
        endif
    endif
endfunction

function! ToggleNofrils()
    if (g:colors_name == 'nofrils-dark')
        colorscheme nofrils-light
    elseif (g:colors_name == 'nofrils-light')
        colorscheme nofrils-dark
    endif
endfunction


" set the colorscheme last to allow any ColorScheme autocmds to get set.
colorscheme nofrils-dark


" Functions and Commands

" http://stackoverflow.com/a/7086709
" call a command and restore view.
function! Preserve(command)
    let w = winsaveview()
    silent execute a:command
    call winrestview(w)
endfunction

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
