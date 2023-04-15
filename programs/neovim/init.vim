set mouse=a

syntax on

set relativenumber
set number
set wildcharm=<C-Z>

set termguicolors

cnoremap <expr> <Up>    pumvisible() ? "\<Left>"  : "\<Up>"
cnoremap <expr> <Down>  pumvisible() ? "\<Right>" : "\<Down>"
cnoremap <expr> <Left>  pumvisible() ? "\<Up>"    : "\<Left>"
cnoremap <expr> <Right> pumvisible() ? "\<Down>"  : "\<Right>"

"This unsets the "last search pattern" register by hitting return
nnoremap <silent> <ESC> :noh<ESC>

let g:tmux_resizer_no_mappings = 1
inoremap jj <ESC>
nnoremap <silent> <C-Left> :TmuxResizeLeft<CR>
nnoremap <silent> <C-Down> :TmuxResizeDown<CR>
nnoremap <silent> <C-Up> :TmuxResizeUp<CR>
nnoremap <silent> <C-Right> :TmuxResizeRight<CR>

nnoremap <silent> <C-q> :try \| tabclose \| catch \| qa \| endtry<CR>
nnoremap <silent> <leader>hh :DiffviewFileHistory %<cr>

set tabstop     =4
set softtabstop =4
set shiftwidth  =4
set expandtab

"Persist undotree history in /tmp
let s:undodir = "/tmp/.undodir_" . $USER
if !isdirectory(s:undodir)
    call mkdir(s:undodir, "", 0700)
endif
let &undodir=s:undodir
set undofile

let g:undotree_WindowLayout = 2
