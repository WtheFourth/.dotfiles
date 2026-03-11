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
alias ls='ls -a --color'
alias cat='bat'
alias vim='nvim'
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

# Dev
# Create a tmux dev session with a git worktree.
# Layout: claude top-left (60%w 70%h), nvim right (40%w), terminal bottom-left (60%w 30%h).
# Usage: dev <session-name> <branch-pattern> [repo-dir]
dev() {
  local no_context=false
  local no_install=false
  local base_branch=""
  local positional=()

  while [[ $# -gt 0 ]]; do
    case $1 in
      --no-context) no_context=true; shift ;;
      --no-install) no_install=true; shift ;;
      --base=*) base_branch="${1#--base=}"; shift ;;
      --base) base_branch="$2"; shift 2 ;;
      *) positional+=("$1"); shift ;;
    esac
  done

  local session="${positional[1]}"
  local branch_pattern="${positional[2]}"
  local repo_dir="${positional[3]:-$PWD}"

  if [[ -z "$session" || -z "$branch_pattern" ]]; then
    echo "Usage: dev [--no-context] [--no-install] [--base=<branch>] <session-name> <branch-pattern> [repo-dir]"
    return 1
  fi

  local root
  root="$(git -C "$repo_dir" rev-parse --show-toplevel 2>/dev/null)" || {
    echo "Not a git repository: $repo_dir"
    return 1
  }

  # Fetch base branch from origin
  local base_ref
  if [[ -n "$base_branch" ]]; then
    git -C "$root" fetch origin "$base_branch" 2>/dev/null
    base_ref="origin/$base_branch"
  elif git -C "$root" fetch origin main 2>/dev/null; then
    base_ref="origin/main"
  else
    git -C "$root" fetch origin master 2>/dev/null
    base_ref="origin/master"
  fi

  local matches
  matches="$(git -C "$root" branch -a | rg -v HEAD | sed 's|remotes/origin/||' | sed 's/^[+* ]*//' | sort -u | rg "$branch_pattern")"

  local branch
  if [[ -z "$matches" ]]; then
    echo "No existing branch matched '$branch_pattern', creating new branch."
    branch="$branch_pattern"
  else
    local count
    count=$(echo "$matches" | rg -c .)
    if [[ "$count" -gt 1 ]]; then
      echo "Multiple branches matched, be more specific:"
      echo "$matches"
      return 1
    fi
    branch="$(echo "$matches" | tr -d ' ')"
  fi

  local safe_name="${branch//\//-}"
  local worktree_path

  # Reuse existing worktree if one exists for this branch
  local existing
  existing="$(git -C "$root" worktree list | rg -F "[$branch]" | awk '{print $1}')"
  if [[ -n "$existing" ]]; then
    echo "Using existing worktree at: $existing"
    worktree_path="$existing"
  else
    worktree_path="$(dirname "$root")/$(basename "$root")-${safe_name}"
    if [[ -z "$matches" ]]; then
      git -C "$root" worktree add -b "$branch" "$worktree_path" "$base_ref" || return 1
    else
      git -C "$root" worktree add "$worktree_path" "$branch" || return 1
    fi
  fi

  local claude_cmd="claude --model opus"
  if [[ "$no_context" == false ]]; then
    claude_cmd="claude --model opus \"/dev-session $session\""
  fi

  # Resolve session name collisions by appending the repo name
  if tmux has-session -t "$session" 2>/dev/null; then
    local repo_name
    repo_name="$(basename "$root")"
    session="${session}-${repo_name}"
    if tmux has-session -t "$session" 2>/dev/null; then
      echo "tmux session '$session' already exists."
      return 1
    fi
    echo "Session name collision, using: $session"
  fi

  # Window 1: claude with init prompt
  tmux new-session -d -s "$session" -c "$worktree_path"
  tmux rename-window -t "$session:1" "claude"
  tmux send-keys -t "$session:1.1" "$claude_cmd" Enter

  # Detect package manager by lockfile
  local setup_cmd=""
  if [[ "$no_install" == false ]]; then
    if [[ -f "$worktree_path/.nvmrc" || -f "$worktree_path/.node-version" ]]; then
      setup_cmd="fnm use && "
    fi
    if [[ -f "$worktree_path/pnpm-lock.yaml" ]]; then
      setup_cmd="${setup_cmd}pnpm install"
    elif [[ -f "$worktree_path/yarn.lock" ]]; then
      setup_cmd="${setup_cmd}yarn install"
    elif [[ -f "$worktree_path/bun.lockb" || -f "$worktree_path/bun.lock" ]]; then
      setup_cmd="${setup_cmd}bun install"
    elif [[ -f "$worktree_path/package-lock.json" || -f "$worktree_path/package.json" ]]; then
      setup_cmd="${setup_cmd}npm install"
    fi
    # C# / .NET projects
    local sln_files=("$worktree_path"/*.sln(N))
    if [[ ${#sln_files[@]} -gt 0 ]]; then
      if [[ -n "$setup_cmd" ]]; then
        setup_cmd="${setup_cmd} && dotnet restore"
      else
        setup_cmd="dotnet restore"
      fi
    fi
  fi

  # Window 2: nvim (top 70%) + terminal (bottom 30%)
  tmux new-window -t "$session" -n "editor" -c "$worktree_path"
  tmux send-keys -t "$session:2.1" "nvim" Enter
  tmux split-window -t "$session:2.1" -v -p 30 -c "$worktree_path"
  if [[ -n "$setup_cmd" ]]; then
    tmux send-keys -t "$session:2.2" "$setup_cmd" Enter
  fi
  tmux select-pane -t "$session:2.1"

  # Window 3: lazygit
  tmux new-window -t "$session" -n "git" -c "$worktree_path"
  tmux send-keys -t "$session:3.1" "lazygit" Enter

  # Start on window 1 (claude)
  tmux select-window -t "$session:1"

  if [[ -n "$TMUX" ]]; then
    tmux switch-client -t "$session"
  else
    tmux attach-session -t "$session"
  fi
}

[[ -f "$HOME/.config/zsh/pdev.zsh" ]] && source "$HOME/.config/zsh/pdev.zsh"

# Keybindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

export _ZO_DOCTOR=0
(( $+commands[zoxide] )) && eval "$(zoxide init zsh --cmd cd)"
export PATH="$HOME/.hudl/claude-telemetry/bin:$PATH"
