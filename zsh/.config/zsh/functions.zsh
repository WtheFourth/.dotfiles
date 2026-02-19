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
  matches="$(git branch -a | grep -v HEAD | sed 's|remotes/origin/||' | sed 's/^[* ]*//' | sort -u | grep "$pattern")"

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
