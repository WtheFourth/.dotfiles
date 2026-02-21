HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory sharehistory
setopt hist_ignore_space hist_ignore_all_dups hist_save_no_dups

autoload -Uz compinit && compinit

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu select

for f in ~/.config/zsh/*.zsh; do source "$f"; done

if command -v tmux &> /dev/null && [[ -z "$TMUX" ]]; then
  tmux attach-session -t main || tmux new-session -s main
fi

alias ls='ls -a --color'
alias cat='bat'
alias vim='nvim'
(( $+commands[rg] )) && alias grep='rg'
if (( $+commands[fd] )); then
  alias find='fd'
elif (( $+commands[fdfind] )); then
  alias fd='fdfind'
  alias find='fdfind'
fi

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
