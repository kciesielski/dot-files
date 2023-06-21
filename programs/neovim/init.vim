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
"Exit input mode with jj 
inoremap jj <ESC> 
nnoremap <silent> <C-Left> :TmuxResizeLeft<CR>
nnoremap <silent> <C-Down> :TmuxResizeDown<CR>
nnoremap <silent> <C-Up> :TmuxResizeUp<CR>
nnoremap <silent> <C-Right> :TmuxResizeRight<CR>

" Close tab (or close nvim if on the main tab!)
nnoremap <silent> <C-q> :try \| tabclose \| catch \| qa \| endtry<CR>
nnoremap <silent> <leader>hh :DiffviewFileHistory %<cr>

" Replace all occurrences of selected text
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>

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


"When a file has been detected to have been changed outside of Vim
"and it has not been changed inside of Vim, automatically read it again.
:set autoread
