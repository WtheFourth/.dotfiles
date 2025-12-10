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

# plugins - using turbo mode for faster startup
zinit wait lucid light-mode for \
  atinit"zicompinit; zicdreplay" \
    zsh-users/zsh-completions \
  atload"_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
    zsh-users/zsh-syntax-highlighting \
    Aloxaf/fzf-tab \
    MichaelAquilina/zsh-you-should-use

# snippets
zinit snippet OMZL::async_prompt.zsh
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZL::nvm.zsh
zinit snippet OMZP::nvm

# compinstall - cache for 24 hours
autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi
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

# NVM - lazy loaded via zinit OMZP::nvm (see line 69 and line 83)
export NVM_DIR="$HOME/.nvm"
# Manual loading removed to enable lazy loading

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

# Pure zsh prompt (fast, no external dependencies)
autoload -U colors && colors
setopt PROMPT_SUBST

# Git info
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats ' %F{141}⎇  %b%f%c%u'
zstyle ':vcs_info:git:*' actionformats ' %F{141}⎇  %b|%a%f%c%u'
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr ' %F{166}●%f'
zstyle ':vcs_info:git:*' unstagedstr ' %F{203}●%f'

precmd() { vcs_info }

# Two-line prompt: Line 1 = path + git, Line 2 = arrow
PROMPT='%F{219}%4~%f${vcs_info_msg_0_}
%F{247}❯%f '

RPROMPT=''

# Defer slow eval commands using zinit turbo mode (after prompt is set up)
zinit ice wait'0a' lucid atload'eval "$(zoxide init zsh --cmd cd)"'
zinit light zdharma-continuum/null

zinit ice wait'0b' lucid atload'eval "$(rbenv init - zsh)"'
zinit light zdharma-continuum/null

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

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"
source ~/code/.ai-commit-config

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/walter.kennedy/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
