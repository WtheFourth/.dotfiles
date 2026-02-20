chpwd() {
  if [[ -f "platform-tools/product-toolkit/selected-product.zsh" ]]; then
    source "platform-tools/product-toolkit/selected-product.zsh"
  fi
}
chpwd

gfm() {
  if git fetch origin main:main 2>/dev/null; then
    git merge main
  else
    git fetch origin master:master && git merge master
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
  matches="$(git branch -a | grep -v HEAD | sed 's|remotes/origin/||' | sed 's/^[+* ]*//' | sort -u | grep "$pattern")"

  if [[ -z "$matches" ]]; then
    echo "No branch found matching: $pattern"
    return 1
  fi

  local count
  count=$(echo "$matches" | grep -c .)
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
  existing="$(git worktree list | grep "\[$branch\]" | awk '{print $1}')"
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
  matches="$(git worktree list | grep "$pattern" | awk '{print $1}')"
  if [[ -z "$matches" ]]; then
    echo "No worktrees found matching: $pattern"
    return 1
  fi

  echo "$matches" | xargs -I{} git worktree remove {}
}

# Create a tmux dev session with a git worktree.
# Layout: claude top-left (60%w 70%h), nvim right (40%w), terminal bottom-left (60%w 30%h).
# Usage: dev <session-name> <branch-pattern> [repo-dir]
dev() {
  local session="$1"
  local branch_pattern="$2"
  local repo_dir="${3:-$PWD}"

  if [[ -z "$session" || -z "$branch_pattern" ]]; then
    echo "Usage: dev <session-name> <branch-pattern> [repo-dir]"
    return 1
  fi

  local root
  root="$(git -C "$repo_dir" rev-parse --show-toplevel 2>/dev/null)" || {
    echo "Not a git repository: $repo_dir"
    return 1
  }

  local matches
  matches="$(git -C "$root" branch -a | grep -v HEAD | sed 's|remotes/origin/||' | sed 's/^[+* ]*//' | sort -u | grep "$branch_pattern")"

  local branch
  if [[ -z "$matches" ]]; then
    echo "No existing branch matched '$branch_pattern', creating new branch."
    branch="$branch_pattern"
  else
    local count
    count=$(echo "$matches" | grep -c .)
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
  existing="$(git -C "$root" worktree list | grep "\[$branch\]" | awk '{print $1}')"
  if [[ -n "$existing" ]]; then
    echo "Using existing worktree at: $existing"
    worktree_path="$existing"
  else
    worktree_path="$(dirname "$root")/$(basename "$root")-${safe_name}"
    if [[ -z "$matches" ]]; then
      git -C "$root" worktree add -b "$branch" "$worktree_path" || return 1
    else
      git -C "$root" worktree add "$worktree_path" "$branch" || return 1
    fi
  fi

  local prompt_file
  prompt_file=$(mktemp)
  sed -e "s/{{BRANCH}}/$safe_name/g" -e "s/{{SESSION}}/$session/g" \
    ~/.config/zsh/dev-prompt.md > "$prompt_file"

  # Window 1: claude with init prompt
  tmux new-session -d -s "$session" -c "$worktree_path"
  tmux rename-window -t "$session:1" "claude"
  tmux send-keys -t "$session:1.1" "claude \"\$(cat $prompt_file && rm $prompt_file)\"" Enter

  # Window 2: nvim (top 70%) + terminal (bottom 30%)
  tmux new-window -t "$session" -n "editor" -c "$worktree_path"
  tmux send-keys -t "$session:2.1" "nvim" Enter
  tmux split-window -t "$session:2.1" -v -p 30 -c "$worktree_path"
  tmux select-pane -t "$session:2.1"

  # Start on window 1 (claude)
  tmux select-window -t "$session:1"

  if [[ -n "$TMUX" ]]; then
    tmux switch-client -t "$session"
  else
    tmux attach-session -t "$session"
  fi
}
