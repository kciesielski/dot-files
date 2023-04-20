My neovim plugins
=================

# LazyGit
Plugin manager, loaded in init.lua. 

## Theme

## Telescope
combined with fzf, opens a search popup window for different use cases
- files
- recent files
- ripgrep (search text in files)
- keymap
- commits
- clipboard (`neoclip` integration)
- undo

## Neotree
`nvim-tree`
- requires `nvim-web-devicons` 
Browsing files in a treelike structure

## Git
`neogit` for all git related commands and the status view
`diffview` for displaying side-by-side views
`gitsigns` for displaying markers on changed lines


## Editor
`indent-blankline` automatically ident on newlines
`nvim-autopairs` adds a pair to opened braces and quotes
`leap` quickjump to any text
`nvim-undotree` show and browse local history

## Other
`tmux` to integrate terminal multiplexing with nvim windows. This way I can jump between tmux panes and nvim windows like they were the same objects.
`which-key` displays a popup with possible key bindings of the command you started typing 