install_oh_my_posh() {
  # Check if we are NOT on Windows
  if ([[ "$(uname)" != "Windows" ]]) then 
    # Check if we have brew installed
    if command -v brew &> /dev/null; then
        echo "Using Homebrew to install Oh My Posh..."
        brew install oh-my-posh
        return 0
    fi
  else 
    # Use winget to install Oh My Posh
    if command -v winget &> /dev/null; then
        echo "Using winget to install Oh My Posh..."
        winget install JanDeDobbeleer.OhMyPosh -s winget
        return 0
    fi
  fi
}

if [[ -o interactive ]]; then
  # Check if Oh My Posh is already installed
  if ! command -v oh-my-posh &> /dev/null; then
      echo "Oh My Posh not found. Install? (y/n)"
      read -q REPLY
      echo
      if [[ $REPLY =~ ^[Yy]$ ]]; then
          install_oh_my_posh
      fi
  else
      return 0
  fi
fi