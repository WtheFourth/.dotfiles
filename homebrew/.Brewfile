# Taps
if OS.mac?
tap "auth0/auth0-cli"
tap "hashicorp/tap"
tap "spacelift-io/spacelift"
tap "wix/brew"
tap "xcodesorg/made"
end
tap "jesseduffield/lazygit"

# Shell
brew "sheldon"
brew "starship"
brew "zoxide"
brew "fzf"
brew "zsh-history-substring-search"
brew "bat"
brew "fd"
brew "ripgrep"
brew "stow"
brew "tmux"
brew "wget"
if OS.mac?
brew "coreutils"
end

# Git
brew "gh"
brew "lazygit"
if OS.mac?
brew "pre-commit"
end

# Languages & version managers
brew "node"
brew "rbenv"
brew "python@3.12"
brew "pyenv"
brew "lua-language-server"

# DevOps / cloud
if OS.mac?
brew "awscli"
brew "tfenv"
brew "tflint"
brew "hashicorp/tap/terraform"
brew "spacelift-io/spacelift/spacectl"
brew "auth0/auth0-cli/auth0"
brew "act"
brew "mkcert"
end
brew "mongosh"

# Mobile
if OS.mac?
brew "watchman"
brew "wix/brew/applesimutils"
brew "xcodesorg/made/xcodes"
end

# Other tools
brew "bob"
brew "gnupg"
brew "redis", restart_service: :changed
if OS.linux?
  brew "openssl@3"
end

# Fonts
cask "font-jetbrains-mono-nerd-font"

# Apps
if OS.mac?
cask "ghostty"
cask "firefox@developer-edition"
cask "microsoft-edge"
cask "rancher"
cask "spotify"
end
