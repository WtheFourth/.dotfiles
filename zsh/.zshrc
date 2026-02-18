HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory sharehistory
setopt hist_ignore_space hist_ignore_all_dups hist_save_no_dups
autoload -Uz compinit && compinit
eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(sheldon source)"
eval "$(starship init zsh)"
eval "$(zoxide init zsh --cmd cd)"
eval "$(rbenv init - zsh)"
source <(fzf --zsh)
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu select
alias ls='ls -a --color'
alias cat='bat'
alias vim='nvim'
export PATH="$HOME/.rbenv/bin:$HOME/.local/bin:$PATH"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh" --no-use
if command -v tmux &> /dev/null && [[ -z "$TMUX" ]]; then
  tmux attach-session -t main || tmux new-session -s main
fi
chpwd() {
  if [[ -f "platform-tools/product-toolkit/selected-product.zsh" ]]; then
    source "platform-tools/product-toolkit/selected-product.zsh"
  fi
}
chpwd
export PATH="$HOME/.rd/bin:$PATH"
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
gfm() {
  if git fetch origin main:main 2>/dev/null; then
    git merge main
  else
    git fetch origin master:master && git merge master
  fi
}
