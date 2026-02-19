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
