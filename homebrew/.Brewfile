# Taps
if OS.mac?
  tap 'auth0/auth0-cli'
  tap 'hashicorp/tap'
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
brew 'git'
brew 'gh'
brew 'lazygit'
brew 'pre-commit' if OS.mac?

# Languages & version managers
brew 'fnm'
brew 'rbenv'
brew 'python@3.12'
brew 'pyenv'

# DevOps / cloud
if OS.mac?
  brew 'awscli'
  brew 'tfenv'
  brew 'tflint'
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
brew 'tree-sitter-cli'
brew 'yq'
brew 'beads'
brew 'gnupg'
brew 'redis', restart_service: :changed
brew 'openssl@3' if OS.linux?

# Fonts
cask 'font-jetbrains-mono-nerd-font'

# Apps
if OS.mac?
  cask 'kitty'
  cask 'firefox@developer-edition'
  cask 'microsoft-edge'
  cask 'rancher'
  cask 'spotify'
end

# VS Code
if OS.mac?
  cask 'visual-studio-code'
  vscode 'anthropic.claude-code'
  vscode 'asvetliakov.vscode-neovim'
  vscode 'astro-build.houston'
  vscode 'catppuccin.catppuccin-vsc'
  vscode 'catppuccin.catppuccin-vsc-icons'
  vscode 'clinyong.vscode-css-modules'
  vscode 'dbaeumer.vscode-eslint'
  vscode 'eamodio.gitlens'
  vscode 'enkia.tokyo-night'
  vscode 'esbenp.prettier-vscode'
  vscode 'formulahendry.dotnet-test-explorer'
  vscode 'george-alisson.html-preview-vscode'
  vscode 'github.copilot-chat'
  vscode 'hashicorp.terraform'
  vscode 'humao.rest-client'
  vscode 'mongodb.mongodb-vscode'
  vscode 'ms-dotnettools.csdevkit'
  vscode 'ms-dotnettools.csharp'
  vscode 'ms-dotnettools.vscode-dotnet-runtime'
  vscode 'ms-vscode.live-server'
  vscode 'ms-vscode.vscode-speech'
  vscode 'ms-vscode.vscode-typescript-next'
  vscode 'msjsdiag.vscode-react-native'
  vscode 'stylelint.vscode-stylelint'
  vscode 'unifiedjs.vscode-mdx'
  vscode 'usernamehw.errorlens'
  vscode 'vitest.explorer'
  vscode 'vscode-icons-team.vscode-icons'
end
