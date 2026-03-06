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
stow zsh tmux nvim kitty
```

Stow creates symlinks from each package directory into `$HOME`, mirroring the folder structure. For example, `stow tmux` links `tmux/.config/tmux/tmux.conf` to `~/.config/tmux/tmux.conf`.

### Neovim

Neovim is managed via [bob](https://github.com/MordechaiHadad/bob):

```sh
bob install nightly
bob use nightly
```

## Packages

| Package      | What it configures                          |
| ------------ | ------------------------------------------- |
| `ghostty`    | Ghostty terminal                            |
| `kitty`      | Kitty terminal (Tokyo Night, cursor trail)  |
| `git`        | Global gitignore                            |
| `homebrew`   | Global Brewfile (`~/.Brewfile`)             |
| `nvim`       | Neovim config                               |
| `starship`   | Starship prompt                             |
| `tmux`       | tmux (Tokyo Night theme, vim-style bindings)|
| `lazygit`    | Lazygit                                     |
| `zsh`        | Zsh config, sheldon plugins, `dev` function |

## Shell utilities

| Command  | Description                                           |
| -------- | ----------------------------------------------------- |
| `dev`    | Spin up a tmux dev session with a git worktree        |
| `gfm`   | Fetch and merge main (or master) into the current branch |
| `gwtaf` | Add a worktree by branch name pattern                 |
| `gwtrmf`| Remove worktrees matching a pattern                   |

### dev

```sh
dev [--no-context] [--no-install] [--base=<branch>] <session-name> <branch-pattern> [repo-dir]
```

Creates a worktree, opens a tmux session with Claude Code, neovim + terminal, and lazygit. Automatically detects the package manager and runs install.

Options:
- `--base=<branch>` — base the worktree off a specific branch instead of main/master
- `--no-context` — skip the initial `/dev-session` prompt to Claude Code
- `--no-install` — skip automatic dependency installation

## Uninstall

Remove symlinks for a package:

```sh
stow -D <package>
```
