install_neovim() {
  if command -v nvim &> /dev/null; then
    return 0 
  fi
  
  echo "Installing Neovim..."
  
  # Check if Homebrew is available
  if command -v brew &> /dev/null; then
    echo "Using Homebrew to install Neovim..."
    brew install neovim
    
    # Check if installation was successful
    if command -v nvim &> /dev/null; then
      echo "Neovim installation complete."
      return 0
    else
      echo "Homebrew installation failed. Falling back to manual installation."
      # Continue to manual installation below
    fi
  else
    echo "Homebrew not found. Proceeding with manual installation."
  fi
  
  # Manual installation process (fallback)
  # Create temporary directory for downloads
  local temp_dir=$(mktemp -d)
  cd "$temp_dir"
  
  # Detect operating system and architecture
  local os_type="linux"
  local arch="x86_64"
  local download_url="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
  
  # Check if running on macOS
  if [[ "$(uname)" == "Darwin" ]]; then
    os_type="macos"
    
    # Check if running on Apple Silicon (ARM64)
    if [[ "$(uname -m)" == "arm64" ]]; then
      arch="arm64"
      download_url="https://github.com/neovim/neovim/releases/latest/download/nvim-macos-arm64.tar.gz"
    else
      # For Intel Macs
      arch="x86_64"
      download_url="https://github.com/neovim/neovim/releases/latest/download/nvim-macos-x86_64.tar.gz"
    fi
  fi
  
  echo "Downloading Neovim for $os_type ($arch)..."
  
  # Download the appropriate release
  curl -LO "$download_url" --silent
  
  if [ $? -ne 0 ]; then
    echo "Failed to download Neovim."
    cd - > /dev/null
    rm -rf "$temp_dir"
    return 1
  fi
  
  # Extract the tarball - get the filename from the URL
  local tarball=$(basename "$download_url")
  echo "Extracting Neovim..."
  tar xzf "$tarball"
  
  # Find the extracted directory
  local extracted_dir=$(find . -type d -name "nvim-*" | head -n 1)
  
  if [ -z "$extracted_dir" ]; then
    echo "Failed to find extracted Neovim directory."
    cd - > /dev/null
    rm -rf "$temp_dir"
    return 1
  fi
  
  # Create directories if they don't exist
  mkdir -p ~/.local/bin ~/.local/share
  
  # Move Neovim to the user's local directory
  mv "$extracted_dir" ~/.local/share/
  
  # Create symbolic link
  ln -sf ~/.local/share/$(basename "$extracted_dir")/bin/nvim ~/.local/bin/nvim
  
  # Clean up
  cd - > /dev/null
  rm -rf "$temp_dir"
  
  # Make sure ~/.local/bin is in PATH
  if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    export PATH="$HOME/.local/bin:$PATH"
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
  fi
  
  echo "Neovim installation complete."
}

# Function to set up Neovim configuration
setup_neovim_config() {
  # Define source and target directories
  local dotfiles_nvim_config="$HOME/.dotfiles/.config/nvim"
  local nvim_config_dir="$HOME/.config/nvim"
  
  # Check if the config exists in dotfiles
  if [[ ! -d "$dotfiles_nvim_config" ]]; then
    return 1  # No config in dotfiles, exit silently
  fi
  
  # Check if a configuration already exists
  if [[ -e "$nvim_config_dir" ]]; then
    return 0  # Config already exists, exit silently
  fi
  
  # If we get here, no existing config was found, so we set up the symlink
  echo "Setting up Neovim configuration..."
  
  # Create parent directory if needed
  mkdir -p "$(dirname "$nvim_config_dir")"
  
  # Create the symlink
  ln -sf "$dotfiles_nvim_config" "$nvim_config_dir"
  
  if [[ $? -eq 0 ]]; then
    echo "Neovim configuration linked to dotfiles."
  else
    echo "Failed to create symlink for Neovim configuration."
    return 1
  fi
}

# Quietly check and conditionally install Neovim when this script is sourced
if [[ -o interactive ]]; then
  # Only run this check once per shell session by setting a flag
  if [[ -z "$__NEOVIM_CHECK_DONE" ]]; then
    __NEOVIM_CHECK_DONE=1
    
    # Check if Neovim is installed
    if ! command -v nvim &> /dev/null; then
      # Prompt only if Neovim isn't installed
      echo "Neovim not found. Install? (y/n)"
      read -q REPLY
      echo
      if [[ $REPLY =~ ^[Yy]$ ]]; then
        install_neovim
        setup_neovim_config
      fi
    else
      # Silently check if config needs to be set up
      setup_neovim_config
    fi
  fi
fi