install_stow() {
 if command -v stow &> /dev/null; then
   return 0
 fi

 if [[ "$(uname)" != "Windows" ]] then
   if command -v brew &> /dev/null; then
     echo "Using Homebrew to install stow"
     brew install stow

     if command -v stow &> /dev/null; then
        echo "Stow installation complete"
        return 0
     else
        echo "Stow installation failed."
     fi
   else
     echo "Homebrew not found, sorry brother, not gonna build it from source."
   fi
 fi
}

if [[ -o interactive ]]; then
  if [[ -z "$__STOW_CHECK_DONE" ]]; then
    __STOW_CHECK_DONE=1

    if ! command -v stow &> /dev/null; then
      echo "Stow not found. Install? (y/n)"
      read -q REPLY
      echo
      if [[ $REPLY =~ ^[Yy]$ ]]; then
        install_stow
      fi
    fi
  fi
fi

