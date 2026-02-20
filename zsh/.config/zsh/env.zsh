[[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
(( $+commands[sheldon] )) && eval "$(sheldon source)"
(( $+commands[starship] )) && eval "$(starship init zsh)"
(( $+commands[zoxide] )) && eval "$(zoxide init zsh --cmd cd)"
(( $+commands[rbenv] )) && eval "$(rbenv init - zsh)"
(( $+commands[fzf] )) && source <(fzf --zsh)

local _fd_cmd=${commands[fd]:-${commands[fdfind]:-}}
if [[ -n "$_fd_cmd" ]]; then
  export FZF_DEFAULT_COMMAND="$_fd_cmd --type f --hidden --exclude .git"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND="$_fd_cmd --type d --hidden --exclude .git"
fi
export PATH="$HOME/.rd/bin:$HOME/.rbenv/bin:$HOME/.local/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh" --no-use
