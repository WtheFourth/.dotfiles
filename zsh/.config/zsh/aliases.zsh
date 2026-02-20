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
