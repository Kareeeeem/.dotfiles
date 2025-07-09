" Settings
set clipboard+=unnamedplus

set showcmd

set scrolloff=3
set nrformats=

set updatetime=50
"set breakindent
set smartindent
set colorcolumn=88
"set formatoptions=tjrocqn
set hidden
set nowrap
set scrolloff=3
set number
set relativenumber
set nojoinspaces  " don't insert double spaces.

set hlsearch ignorecase smartcase incsearch
set expandtab tabstop=4 softtabstop=4 shiftwidth=4
set signcolumn=number

set noswapfile
set nobackup
set dir=$HOME/.vim/tmp
set undofile undodir=$HOME/.vim/undodir/

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
" " Break line
nnoremap <leader>k i<cr><esc>kg$
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

" Don't use Ex mode.
map Q <nop>

call plug#begin()
Plug 'nvim-lua/plenary.nvim'  " this is a dependency of many other plugins

Plug 'mbbill/undotree', {'on': 'UndotreeToggle'}
Plug 'moll/vim-bbye', {'on': 'Bdelete'}
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'nvim-lualine/lualine.nvim'
Plug 'camspiers/lens.vim' " auto resizing for buffers

" tmux
Plug 'jpalardy/vim-slime'
Plug 'christoomey/vim-tmux-navigator'

" lsp
Plug 'neovim/nvim-lspconfig'
Plug 'stevearc/conform.nvim'
Plug 'mfussenegger/nvim-lint'

" colorschemes
Plug 'https://git.sr.ht/~romainl/vim-bruin'
Plug 'LuRsT/austere.vim'
Plug 'andreypopp/vim-colors-plain'
Plug 'pbrisbin/vim-colors-off'
Plug 'chriskempson/base16-vim'
Plug 'robertmeta/nofrils'
Plug 'huyvohcmc/atlas.vim'
Plug 'plan9-for-vimspace/acme-colors'
Plug 'rose-pine/neovim'

" search
Plug 'nvim-telescope/telescope.nvim', { 'branch': '0.1.x' }
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

" completion
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'

" python
Plug 'hynek/vim-python-pep8-indent'
Plug 'Kareeeeem/python-docstring-comments'

call plug#end()

" lens
let g:lens#disabled_filetypes = ['undotree', 'diff']
let g:lens#width_resize_max = 92

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

" Undotree
nnoremap <F5> :UndotreeToggle<cr>
let g:undotree_SetFocusWhenToggle = 1

" Colorscheme
function! ModifyNoFrils()
    " Some modifications I like for nofrils
    if (&cursorline)
        hi clear CursorLineNr
        hi link CursorLineNr Normal
    endif

    hi TODO gui=bold cterm=bold

    if (g:colors_name == 'nofrils-dark')
        hi Normal guibg=NONE ctermbg=NONE
    endif
endfunction

augroup theme
    au!
    au ColorScheme nofrils* call ModifyNoFrils()
augroup END

if &diff
    colorscheme blue
else
    colorscheme nofrils-dark
endif


augroup languages
    au!
    au FileType *markdown*,text setlocal fo+=t tw=72 wrap

    au FileType awk setlocal commentstring=#\ %s

    au FileType rc setlocal commentstring=#\ %s
    au FileType lua,rkt,yaml,ruby,lisp,html,js,typescriptreact,typescript,javascriptreact,javascript setlocal tabstop=2 softtabstop=2 shiftwidth=2

    " for writing printer labels, once used it at work. will leave it in the
    " off chance I might need it again.
    au BufRead,BufNewFile *.zpl set filetype=zpl
    au FileType zpl setlocal commentstring=^FX\ %s
augroup END

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

luafile $HOME/.dotfiles/vimrc.lua
