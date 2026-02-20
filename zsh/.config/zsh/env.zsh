eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(sheldon source)"
eval "$(starship init zsh)"
eval "$(zoxide init zsh --cmd cd)"
eval "$(rbenv init - zsh)"
source <(fzf --zsh)

export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'
export PATH="$HOME/.rd/bin:$HOME/.rbenv/bin:$HOME/.local/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh" --no-use
