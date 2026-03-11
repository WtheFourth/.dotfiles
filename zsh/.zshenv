# Homebrew — set up for ALL shell contexts (interactive, scripts, IDE terminals)
# This ensures /opt/homebrew/bin is always before /usr/bin.
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
