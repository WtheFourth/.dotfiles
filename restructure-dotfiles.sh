#!/bin/bash

set -e

DRY_RUN=false
if [ "$1" == "--dry-run" ]; then
    DRY_RUN=true
    echo "🟡 Running in DRY RUN mode. No changes will be made."
fi

DOTFILES_DIR="$HOME/.dotfiles"

cd "$DOTFILES_DIR"

run() {
    if $DRY_RUN; then
        echo "[DRY RUN] $*"
    else
        eval "$*"
    fi
}

# Step 1: Create nvim package if it doesn't exist
if [ ! -d "$DOTFILES_DIR/nvim/.config/nvim" ]; then
    echo "Creating nvim package..."
    run "mkdir -p \"$DOTFILES_DIR/nvim/.config\""
    if [ -d "$DOTFILES_DIR/.config/nvim" ]; then
        run "mv \"$DOTFILES_DIR/.config/nvim\" \"$DOTFILES_DIR/nvim/.config/\""
    fi
else
    echo "nvim package already exists. Skipping move."
fi

# Step 2: Remove ~/.config symlink if it exists
if [ -L "$HOME/.config" ]; then
    echo "Removing existing ~/.config symlink..."
    run "rm \"$HOME/.config\""
else
    echo "~/.config symlink not found. Skipping."
fi

# Step 3: Clean up .config folder inside dotfiles repo if empty
if [ -d "$DOTFILES_DIR/.config" ] && [ -z "$(ls -A "$DOTFILES_DIR/.config")" ]; then
    echo "Removing empty .config folder from dotfiles..."
    run "rmdir \"$DOTFILES_DIR/.config\""
elif [ -d "$DOTFILES_DIR/.config" ]; then
    echo "⚠️ Warning: .config still has contents. Manual review recommended."
else
    echo ".config folder already removed."
fi

# Step 4: Stow specific packages
PACKAGES=(nvim theme scripts)

for pkg in "${PACKAGES[@]}"; do
    if [ -d "$DOTFILES_DIR/$pkg" ]; then
        echo "Stowing $pkg package..."
        run "stow $pkg"
    else
        echo "⚠️ Package '$pkg' not found. Skipping."
    fi
done

# Step 5: Stow remaining top-level dotfiles
echo "Stowing top-level dotfiles (e.g., .zshrc, .wezterm.lua)..."
run "stow ."

echo "✅ Done!"

if $DRY_RUN; then
    echo "ℹ️ This was a dry run. Run without --dry-run to apply changes."
fi
