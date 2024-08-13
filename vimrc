" General settings

" nvim python host prog
let g:python3_host_prog = '$HOME/.venv-py3nvim/bin/python'

set clipboard+=unnamedplus
set notermguicolors

set wildmenu
set showcmd

set scrolloff=3
set nrformats=
set updatetime=500
set breakindent
set completeopt+=menuone
set completeopt-=preview
set autoindent
set backspace=2
set colorcolumn=88
" set winwidth=92  " taken care of by the lens plugin
set encoding=utf-8
set fileencoding=utf-8
set formatoptions=tjrocqn
set hidden
set nowrap
set scrolloff=3
set pastetoggle=<F6>
set number
set nojoinspaces  " don't insert double spaces.

set hlsearch ignorecase smartcase incsearch
set expandtab tabstop=4 softtabstop=4 shiftwidth=4
set signcolumn=number

set dir=$HOME/.vim/tmp
set undofile undodir=$HOME/.vim/undodir/

let c_no_curly_error = 1
let c_syntax_for_h = 1

if executable("rg")
    set grepprg=rg\ --vimgrep\ --no-heading
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

" Mappings

tnoremap <Esc> <C-\><C-n>
" Expand `%%` to current directory.
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'
" Because backslash is in a awkward place.
let mapleader = "\<Space>"
" " I almost never want to go to the ABSOLUTE beginning of a line
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
" http://vi.stackexchange.com/a/440
" Like gJ, but always remove spaces
function! JoinSpaceless()
    execute 'normal gJ'
    " Character under cursor is whitespace remove it.
    if matchstr(getline('.'), '\%' . col('.') . 'c.') =~ '\s'
        execute 'normal dw'
    endif
endfunction

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
nnoremap <C-p> :bp<cr>
nnoremap <C-n> :bn<cr>

nnoremap ]g :lnext<cr>
nnoremap [g :lprev<cr>

" Don't use Ex mode.
map Q <nop>


" Plugins

function! PlugLoaded(name)
    return (
        \ has_key(g:plugs, a:name) &&
        \ isdirectory(g:plugs[a:name].dir) &&
        \ stridx(&rtp, g:plugs[a:name].dir) >= 0)
endfunction

call plug#begin('~/.vim/plugged')

Plug 'nvim-lua/plenary.nvim'  " this is a dependency of many other plugins

Plug 'mbbill/undotree', {'on': 'UndotreeToggle'}
Plug 'moll/vim-bbye', {'on': 'Bdelete'}
Plug 'ap/vim-buftabline'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'nvim-lualine/lualine.nvim'
Plug 'camspiers/lens.vim' " auto resizing for buffers

" tmux
Plug 'jpalardy/vim-slime'
Plug 'christoomey/vim-tmux-navigator'

" fuzzy finding
Plug 'nvim-telescope/telescope.nvim', { 'branch': '0.1.x' }
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

" language help

" general
Plug 'nvim-treesitter/nvim-treesitter'
" Plug 'github/copilot.vim'

" lsp
Plug 'neovim/nvim-lspconfig'
Plug 'jose-elias-alvarez/null-ls.nvim'

" completion
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'

" dap
" Plug 'mfussenegger/nvim-dap'
" Plug 'mfussenegger/nvim-dap-python'
" Plug 'mxsdev/nvim-dap-vscode-js'

" python
Plug 'alfredodeza/pytest.vim'
Plug 'psf/black', {'branch': 'stable'}
Plug 'hynek/vim-python-pep8-indent'
Plug 'Kareeeeem/python-docstring-comments'

" racket
Plug 'benknoble/vim-racket'

" arduino
Plug 'stevearc/vim-arduino'

" colorschemes
Plug 'robertmeta/nofrils'

call plug#end()

" lens
let g:lens#disabled_filetypes = ['undotree', 'diff']
let g:lens#width_resize_max = 92


" buftabline
" let g:buftabline_numbers = 1
let g:buftabline_indicators = 1

" Tmux navigator
let g:tmux_navigator_disable_when_zoomed=1

" vim bbye
nnoremap <leader>q :Bdelete<cr>

" Slime
let g:slime_target = 'tmux'
let g:slime_python_ipython = 1
let g:slime_bracketed_paste = 1
let g:slime_no_mappings = 1
xmap <leader>s <Plug>SlimeRegionSend
nmap <leader>s <Plug>SlimeParagraphSend
nmap <leader>v <Plug>SlimeConfig

" arduino
let g:arduino_use_slime = 1
let g:arduino_home_dir = "$HOME/.arduino15"
let g:arduino_dir = "$HOME/.arduino15"

" black
let g:black_fast = 1
let g:black_skip_string_normalization = 0

" vim-racket
let g:racket_hash_lang_dict = { 'sicp': 'racket' }



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
augroup END

let whitespace_blacklist = []
augroup cleanup
    au!

    " strip trailing whitespace.
    au BufWritePre * if index(whitespace_blacklist, &ft) < 0
                \ | call Preserve('%s/\s\+$//ge')
                \ | endif
    " strip trailing white lines.
    au BufWritePre * call Preserve('v/\n*./d')
augroup END

augroup languages
    au!
    au BufWritePre *.go call Preserve('%!gofmt')

    au FileType python inoremap <buffer> pdb breakpoint()<esc>
    au BufWritePre *.py execute ':Black'

    " vim-racket overrides my K mapping
    au FileType racket nunmap <buffer> K
    au FileType racket,scheme setlocal commentstring=;\ %s


    au FileType *markdown*,text setlocal fo+=t tw=72 wrap
    " au FileType sh setlocal noexpandtab
    " au FileType c setlocal commentstring=//\ %s
    " au FileType c setlocal cinoptions+=:0 " Don't indent case
    au FileType awk setlocal commentstring=#\ %s
    au FileType htmljinja,htmldjango setlocal commentstring={#\ %s\ #}
    au FileType php setlocal commentstring=//\ %s
    au FileType xdefaults setlocal commentstring=!\ %s
    au FileType rc setlocal commentstring=#\ %s
    au FileType rkt,yaml,ruby,lisp,html,js,typescriptreact,typescript,javascriptreact,javascript setlocal tabstop=2 softtabstop=2 shiftwidth=2
    au FileType typescript,typescriptreact,javascriptreact setlocal smartindent

    " for writing printer labels, once used it at work. will leave it in the
    " off chance I might need it again.
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
function! ModifyNoFrils()
    " Some modifications I like for nofrils
    if (&cursorline)
        hi clear CursorLineNr
        hi link CursorLineNr Normal
    endif

    hi TODO cterm=bold

    if (g:colors_name == 'nofrils-dark')
        " brighten the comments
        hi Comment ctermfg=243
        " dim the normal text a little bit.
        hi Normal ctermfg=250
        hi LineNr ctermfg=243
        " use my terminal background
        hi Normal ctermbg=NONE
        hi LineNr ctermbg=NONE
        hi SignColumn ctermbg=NONE
    elseif (g:colors_name == 'nofrils-light')
        hi Comment ctermfg=243
        hi Normal ctermbg=252
        hi ColorColumn ctermbg=251
        hi LineNr ctermbg=253
        hi SignColumn ctermbg=253
    endif
endfunction

function! ToggleNofrils()
    if (g:colors_name == 'nofrils-dark')
        colorscheme nofrils-light
    elseif (g:colors_name == 'nofrils-light')
        colorscheme nofrils-dark
    endif
endfunction

augroup theme
    au!
    au ColorScheme nofrils* call ModifyNoFrils()
    " au ColorScheme nofrils* nnoremap <F7> :call ToggleNofrils()<cr>
augroup END


if &diff
    colorscheme blue
else
    colorscheme nofrils-dark
endif

" Functions and Commands

" http://stackoverflow.com/a/7086709
" call a command and restore view.
function! Preserve(command)
    let w = winsaveview()
    silent execute a:command
    call winrestview(w)
endfunction

function! QuickFixOpenAll()
    if empty(getqflist())
        return
    endif
    let s:prev_val = ""
    for d in getqflist()
        let s:curr_val = bufname(d.bufnr)
        if (s:curr_val != s:prev_val)
            exec "edit " . s:curr_val
        endif
        let s:prev_val = s:curr_val
    endfor
endfunction

command! QuickFixOpenAll call QuickFixOpenAll()

luafile $HOME/.dotfiles/vimrc.lua
