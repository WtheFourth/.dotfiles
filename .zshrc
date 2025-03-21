if [ -n "${ZSH_DEBUGRC+1}" ]; then
    zmodload zsh/zprof
fi

# zsh history
HISTFILE=~/.histfile
HISTSIZE=5000
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
# End zsh history

# other zsh options
bindkey -v
unsetopt autocd beep notify

# zinit installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust
# End zinit installer

if [[ "$(uname)" == "Darwin" ]] then
    # Check for Homebrew on Apple Silicon Macs
    if [[ -f "/opt/homebrew/bin/brew" ]] then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    # Check for Homebrew on Intel Macs
    elif [[ -f "/usr/local/bin/brew" ]] then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
elif [[ "$(uname)" == "Linux" ]] then 
    if [[ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]] then
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi

    if command -v psql &>/dev/null || [ -d /etc/postgresql ]; then
      if service postgresql status 2>&1 | grep -q "is not running"; then
        sudo service postgresql start
      fi
    fi

    if command -v redis-server &>/dev/null || [ -f /etc/redis/redis.conf ]; then
      if service redis-server status 2>&1 | grep -q "is not running"; then
        sudo service redis-server start
      fi
    fi
fi

zstyle ':omz:plugins:nvm' lazy yes

# plugins
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light MichaelAquilina/zsh-you-should-use

# snippets
zinit snippet OMZL::async_prompt.zsh
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZL::nvm.zsh
zinit snippet OMZP::nvm

# compinstall
autoload -Uz compinit && compinit
zinit cdreplay -q
# End compinstall

# keybinds
bindkey '^a' history-search-backward
bindkey '^z' history-search-forward
bindkey '^[w' kill-region

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -a --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls -a --color $realpath'

# Aliases
alias ls='ls -a --color'
alias vim='nvim'

# Environment variables and additional configurations
export PATH="$HOME/.rbenv/bin:$PATH"
export PATH=$PATH:$HOME/.local/bin

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# End NVM

# Setup dev environment
# Define dotfiles directory
DOTFILES_DIR="$HOME/.dotfiles"

# Source all script files
if [[ -d "$DOTFILES_DIR/scripts" ]]; then
  for script in "$DOTFILES_DIR/scripts"/*.zsh; do
    if [[ -f "$script" ]]; then
      source "$script"
    fi
  done
fi

# Integrations
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(zoxide init zsh --cmd cd)"
eval "$(rbenv init - zsh)"
eval "$(oh-my-posh init zsh --config $DOTFILES_DIR/theme/.wk4.omp.json)"

# fzf defaults
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'

if [ -n "${ZSH_DEBUGRC+1}" ]; then
    zprof
fi

if [[ "$(uname)" == "Darwin" ]] then
  ### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
  export PATH="/Users/walter.kennedy/.rd/bin:$PATH"
  ### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
fi
