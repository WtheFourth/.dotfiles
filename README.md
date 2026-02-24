# dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Install

Install [Homebrew](https://brew.sh) if you don't have it, then:

```sh
git clone <repo-url> ~/.dotfiles
cd ~/.dotfiles
brew bundle --file=homebrew/.Brewfile
stow */
```

Or stow individual packages:

```sh
stow zsh tmux nvim ghostty
```

Stow creates symlinks from each package directory into `$HOME`, mirroring the folder structure. For example, `stow tmux` links `tmux/.config/tmux/tmux.conf` to `~/.config/tmux/tmux.conf`.

## Packages

| Package      | What it configures                          |
| ------------ | ------------------------------------------- |
| `ghostty`    | Ghostty terminal                            |
| `git`        | Global gitignore                            |
| `homebrew`   | Global Brewfile (`~/.Brewfile`)             |
| `nvim`       | Neovim (stable + nightly configs)           |
| `starship`   | Starship prompt                             |
| `tmux`       | tmux (Tokyo Night theme, vim-style bindings)|
| `wezterm`    | WezTerm terminal                            |
| `zsh`        | Zsh config, sheldon plugins, `dev` function |

## Shell utilities

The zsh config includes a `dev` function for spinning up tmux workspaces with git worktrees:

```sh
dev <session-name> <branch-pattern> [repo-dir]
```

This creates a worktree, opens a tmux session with Claude Code in one window and neovim + a terminal in another.

## Uninstall

Remove symlinks for a package:

```sh
stow -D <package>
```
