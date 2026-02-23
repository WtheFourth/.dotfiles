# Taps
if OS.mac?
  tap 'auth0/auth0-cli'
  tap 'hashicorp/tap'
  tap 'spacelift-io/spacelift'
  tap 'wix/brew'
  tap 'xcodesorg/made'
end
tap 'jesseduffield/lazygit'

# Shell
brew 'sheldon'
brew 'starship'
brew 'zoxide'
brew 'fzf'
brew 'zsh-history-substring-search'
brew 'bat'
brew 'fd'
brew 'ripgrep'
brew 'stow'
brew 'tmux'
brew 'wget'
brew 'coreutils' if OS.mac?

# Git
brew 'gh'
brew 'lazygit'
brew 'pre-commit' if OS.mac?

# Languages & version managers
brew 'node'
brew 'rbenv'
brew 'python@3.12'
brew 'pyenv'

# DevOps / cloud
if OS.mac?
  brew 'awscli'
  brew 'tfenv'
  brew 'tflint'
  brew 'spacelift-io/spacelift/spacectl'
  brew 'auth0/auth0-cli/auth0'
  brew 'act'
  brew 'mkcert'
end
brew 'mongosh'

# Mobile
if OS.mac?
  brew 'watchman'
  brew 'wix/brew/applesimutils'
  brew 'xcodesorg/made/xcodes'
end

# Other tools
brew 'bob'
brew 'gnupg'
brew 'redis', restart_service: :changed
brew 'openssl@3' if OS.linux?

# Fonts
cask 'font-jetbrains-mono-nerd-font'

# Apps
if OS.mac?
  cask 'ghostty'
  cask 'firefox@developer-edition'
  cask 'microsoft-edge'
  cask 'rancher'
  cask 'spotify'
end
