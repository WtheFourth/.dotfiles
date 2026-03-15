# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory sharehistory
setopt hist_ignore_space hist_ignore_all_dups hist_save_no_dups

# Completion
autoload -Uz compinit && compinit

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu no
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':fzf-tab:complete:cd:*' fzf-preview '(eza -1 --color=always $realpath 2>/dev/null || ls -1 --color=always $realpath)'
zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
zstyle ':fzf-tab:*' popup-min-size 60 20

# Plugins
# Tmux
if command -v tmux &> /dev/null && [[ -z "$TMUX" ]]; then
  tmux attach-session -t main || tmux new-session -s main
fi

# Aliases
if (( $+commands[bat] )); then
  alias cat='bat'
fi
if (( $+commands[nvim] )); then
  alias vim='nvim'
fi
if (( $+commands[fdfind] )); then
  alias fd='fdfind'
fi
nvm() {
  if [[ "$1" == "use" ]]; then
    fnm use "${@:2}"
  else
    echo "nvm is not installed. Did you mean fnm $1?"
    return 1
  fi
}

# Environment
(( $+commands[sheldon] )) && eval "$(sheldon source)"
(( $+commands[starship] )) && eval "$(starship init zsh)"
(( $+commands[rbenv] )) && eval "$(rbenv init - zsh)"
(( $+commands[fzf] )) && source <(fzf --zsh)

local _fd_cmd=${commands[fd]:-${commands[fdfind]:-}}
if [[ -n "$_fd_cmd" ]]; then
  export FZF_DEFAULT_COMMAND="$_fd_cmd --type f --hidden --exclude .git"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND="$_fd_cmd --type d --hidden --exclude .git"
fi
export EDITOR="nvim"
export VISUAL="nvim"
export XDG_CONFIG_HOME="$HOME/.config"
export PATH="$HOME/.local/share/bob/nvim-bin:$HOME/.rd/bin:$HOME/.rbenv/bin:$HOME/.local/bin:$PATH"

(( $+commands[fnm] )) && eval "$(fnm env --use-on-cd --shell zsh)"

# Hooks
chpwd() {
  if [[ -f "platform-tools/product-toolkit/selected-product.zsh" ]]; then
    source "platform-tools/product-toolkit/selected-product.zsh"
  fi
}
chpwd

# Git
gfm() {
  if git fetch origin main 2>/dev/null; then
    git merge origin/main
  else
    git fetch origin master && git merge origin/master
  fi
}

# Add a worktree by branch name pattern.
# Searches local and remote branches, errors if ambiguous.
# Worktree is created as a sibling of the repo root.
gwtaf() {
  local pattern="$1"
  if [[ -z "$pattern" ]]; then
    echo "Usage: gwtaf <branch-pattern>"
    return 1
  fi
  local root
  root="$(git rev-parse --show-toplevel)" || return 1

  local matches
  matches="$(git branch -a | rg -v HEAD | sed 's|remotes/origin/||' | sed 's/^[+* ]*//' | sort -u | rg "$pattern")"

  if [[ -z "$matches" ]]; then
    echo "No branch found matching: $pattern"
    return 1
  fi

  local count
  count=$(echo "$matches" | rg -c .)
  if [[ "$count" -gt 1 ]]; then
    echo "Multiple branches matched, be more specific:"
    echo "$matches"
    return 1
  fi

  local branch
  branch="$(echo "$matches" | tr -d ' ')"
  local safe_name="${branch//\//-}"
  local path
  path="$(dirname "$root")/$(basename "$root")-${safe_name}"

  # Reuse existing worktree if one exists for this branch
  local existing
  existing="$(git worktree list | rg -F "[$branch]" | awk '{print $1}')"
  if [[ -n "$existing" ]]; then
    echo "Worktree already exists at: $existing"
    return 0
  fi

  git worktree add "$path" "$branch"
}

# Remove worktrees whose path or branch name matches a pattern.
gwtrmf() {
  local pattern="$1"
  if [[ -z "$pattern" ]]; then
    echo "Usage: gwtrmf <pattern>"
    return 1
  fi

  local matches
  matches="$(git worktree list | rg "$pattern" | awk '{print $1}')"
  if [[ -z "$matches" ]]; then
    echo "No worktrees found matching: $pattern"
    return 1
  fi

  echo "$matches" | xargs -I{} git worktree remove {}
}

[[ -f "$HOME/.config/zsh/pdev.zsh" ]] && source "$HOME/.config/zsh/pdev.zsh"

# Keybindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

export _ZO_DOCTOR=0
if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh)"
  alias cd='z'
  alias cdi='zi'
fi
export PATH="$HOME/.hudl/claude-telemetry/bin:$PATH"
