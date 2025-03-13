install_rbenv() {
  # Check if we are NOT on Windows
  if [[ "$(uname)" != "Windows" ]]; then
    # Check if we have brew installed
    if command -v brew &> /dev/null; then
      echo "Using Homebrew to install rbenv..."
      brew install rbenv
      return 0
    else 
      # just build from source
      echo "Building rbenv from source..."
      git clone https://github.com/rbenv/rbenv.git ~/.rbenv     
    fi
  fi
}

if [[ -o interactive ]]; then
  # Check if rbenv is already installed
  if ! command -v rbenv &> /dev/null; then
    echo "rbenv not found. Install? (y/n)"
    read -q REPLY
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      install_rbenv
    fi
  else
    return 0
  fi
fi