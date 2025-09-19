export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="awesomepanda"

plugins=(git)

source $ZSH/oh-my-zsh.sh

alias ff="fastfetch"
alias vi="nvim"
alias ls="eza -la --color=always --icons=always"
