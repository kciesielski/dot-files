# :: Zplug - ZSH plugin manager
export ZPLUG_HOME=$HOME/.zplug

# Check if zplug is installed
if [[ ! -d $ZPLUG_HOME ]]; then
  git clone https://github.com/zplug/zplug $ZPLUG_HOME
  source $ZPLUG_HOME/init.zsh && zplug update --self
fi

source $ZPLUG_HOME/init.zsh

zplug 'zplug/zplug', hook-build:'zplug --self-manage'

zplug "zsh-users/zsh-completions",              defer:0
zplug "zsh-users/zsh-autosuggestions",          defer:2, on:"zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting",      defer:3, on:"zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-history-substring-search"

zplug "plugins/shrink-path", from:oh-my-zsh
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/common-aliases",   from:oh-my-zsh

zplug "themes/robbyrussell", from:oh-my-zsh

alias ls="ls --color"
alias ll="ls -l --color"
alias la="ls -a --color"

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

export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000