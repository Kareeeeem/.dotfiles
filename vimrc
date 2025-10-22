" Settings
set clipboard+=unnamedplus

set showcmd
set mouse=

set completeopt+=fuzzy,menuone,noinsert,nosort
set scrolloff=3
set nrformats=

set wildignorecase
set updatetime=50
set colorcolumn=88
"set formatoptions=tjrocqn
set hidden
set nowrap
set scrolloff=3
set number
set relativenumber

set hlsearch ignorecase smartcase incsearch
set expandtab tabstop=4 softtabstop=4 shiftwidth=4
set signcolumn=number

set noswapfile
set nobackup
set dir=$HOME/.vim/tmp
set undofile undodir=$HOME/.vim/undodir/

if executable("rg")
    set grepprg=rg\ --vimgrep\ --no-heading
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

" Mappings

" Expand `%%` to current directory.
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'
" Because backslash is in a awkward place.
let mapleader = "\<Space>"
" " I almost never want to go to the ABSOLUTE beginning of a line
" nnoremap 0 ^
" nnoremap ^ 0
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

nnoremap <leader>w :update<cr>
nnoremap <leader>z :wqa<cr>

" omnicomplete
inoremap <C-space> <C-x><C-o>

" Don't use Ex mode.
map Q <nop>

command SilentMake execute "silent make!"
nnoremap <leader>m :SilentMake<cr>

" sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
"        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
call plug#begin()
Plug 'nvim-lua/plenary.nvim'  " this is a dependency of many other plugins

Plug 'mbbill/undotree', {'on': 'UndotreeToggle'}
Plug 'moll/vim-bbye', {'on': ['Bdelete', 'Bwipeout']}
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'nvim-lualine/lualine.nvim'

" tmux
Plug 'jpalardy/vim-slime'
Plug 'christoomey/vim-tmux-navigator'

" lsp
Plug 'neovim/nvim-lspconfig'
Plug 'stevearc/conform.nvim'
Plug 'mfussenegger/nvim-lint'

" colorschemes
Plug 'robertmeta/nofrils'

" search
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" python
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'Kareeeeem/python-docstring-comments'

call plug#end()

" Tmux navigator
let g:tmux_navigator_disable_when_zoomed=1

" fzf
nnoremap <leader>p :Files<cr>
nnoremap <leader>g :Rg<cr>
nnoremap <leader>b :Buffers<cr>
nnoremap <leader>h :History<cr>
let g:fzf_vim = {}

let g:fzf_vim.preview_window = ['up,50%']
let g:fzf_vim.files_options = ['--cycle']
let g:fzf_vim.rg_options = ['--cycle']
let g:fzf_vim.buffers_options = ['--cycle']
let g:fzf_vim.history_options = ['--cycle']

" vim bbye
nnoremap <leader>q :Bwipeout<cr>

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
    au FileType python setlocal keywordprg=pydoc3

    au FileType rc setlocal commentstring=#\ %s
    au FileType lua,rkt,yaml,ruby,lisp,html,json,js,typescriptreact,typescript,javascriptreact,javascript setlocal tabstop=2 softtabstop=2 shiftwidth=2

    " for writing printer labels, will leave it in the off chance I might need
    " it again.
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
