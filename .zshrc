# :: Zplug - ZSH plugin manager
export ZPLUG_HOME=$HOME/.zplug

# Check if zplug is installed
if [[ ! -d $ZPLUG_HOME ]]; then
  git clone https://github.com/zplug/zplug $ZPLUG_HOME
  source $ZPLUG_HOME/init.zsh && zplug update --self
fi

source $ZPLUG_HOME/init.zsh

zplug 'zplug/zplug', hook-build:'zplug --self-manage'

zplug "b4b4r07/enhancd", use:init.sh
export ENHANCD_FILTER=fzf

zplug "zsh-users/zsh-completions",              defer:0
zplug "zsh-users/zsh-autosuggestions",          defer:2, on:"zsh-users/zsh-completions"
zplug "zdharma/fast-syntax-highlighting",       defer:3, on:"zsh-users/zsh-autosuggestions"
export ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)


zplug "plugins/git", from:oh-my-zsh
zplug "plugins/common-aliases",   from:oh-my-zsh
zplug "plugins/sudo", from:oh-my-zsh
zplug "plugins/docker", from:oh-my-zsh
zplug "plugins/docker-compose", from:oh-my-zsh
zplug "plugins/helm", from:oh-my-zsh
zplug "plugins/extract", from:oh-my-zsh
zplug "plugins/docker", from:oh-my-zsh
zplug "direnv/direnv", as:command, rename-to:direnv, use:"direnv", hook-build:"make"
zplug "mafredri/zsh-async", from:github
zplug "dracula/zsh", as:theme

zplug "modules/history", from:prezto

alias cdh="cd ~"
alias ls="ls --color"
alias ll="ls -l --color"
alias la="ls -a --color"
alias bfg9k="docker system prune --force --all --volume"
zplug "dbkaplun/smart-cd" # automatic ls in dirs, git status in repos

#zplug "plugins/kubectl", from:oh-my-zsh, defer:2
#zplug "bonnefoa/kubectl-fzf", defer:3

export NVM_LAZY_LOAD=true
zplug "lukechilds/zsh-nvm"
zplug "cswl/zsh-rbenv"
zplug "nobeans/zsh-sdkman"
#zplug "superbrothers/zsh-kubectl-prompt"

zplug "changyuheng/fz", defer:1
zplug "rupa/z", use:z.sh


zplug "junegunn/fzf-bin", as:command, from:gh-r, rename-to:fzf
zplug "junegunn/fzf", from:github, use:"shell/completion.zsh"
zplug "junegunn/fzf", from:github, use:"shell/key-bindings.zsh"
zplug "sharkdp/fd", as:command, from:gh-r, rename-to:fdd

zplug "zdharma/zsh-diff-so-fancy", as:command, use:bin/git-dsf
zplug 'wfxr/forgit', defer:1
zplug "MichaelAquilina/zsh-you-should-use"
zplug 'b4b4r07/copy', as:command, use:'(*).sh', rename-to:'$1'

# golang: initialize GOPATH
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH

 # Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# https://gist.github.com/anchor/4076792
autoload -U select-word-style
select-word-style bash


zplug load
RPROMPT='%{$fg[blue]%}%{$reset_color%}'

export FZF_CTRL_T_OPTS="--ansi --preview-window 'right:60%' --preview 'bat --color=always --style=header,grid --line-range :300 {}'"
export FZF_CTRL_T_COMMAND="fdd -I --type file"

autoload -U edit-command-line
# Emacs style
zle -N edit-command-line
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/kc/.sdkman"
python3 ~/simplingo.py
[[ -s "/home/kc/.sdkman/bin/sdkman-init.sh" ]] && source "/home/kc/.sdkman/bin/sdkman-init.sh"
