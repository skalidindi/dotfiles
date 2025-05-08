# Dotfiles

A collection of personal configuration files for various tools and applications to quickly set up a consistent development environment across different machines.

## What are Dotfiles?

Dotfiles are configuration files in Unix-like systems that begin with a dot (.) and control the behavior of various applications and shells. This repository organizes these configuration files to make them easy to install and manage across different machines.

## Included Configurations

This repository includes configurations for:

- **aerospace** - Window manager configuration
- **alacritty** - Terminal emulator configuration
- **bash** - Bash shell configuration
- **bat** - Cat clone with syntax highlighting
- **bin** - Custom scripts and binaries
- **btop** - System monitor configuration
- **fastfetch** - System information display
- **gh** - GitHub CLI configuration
- **ghostty** - Terminal emulator configuration
- **git** - Git version control configuration
- **kitty** - Terminal emulator configuration
- **misc** - Miscellaneous configuration files
- **nvim** - Neovim text editor configuration
- **skhd** - Simple hotkey daemon configuration
- **tmux** - Terminal multiplexer configuration
- **zsh** - Zsh shell configuration

## Prerequisites

- [GNU Stow](https://www.gnu.org/software/stow/) - Symlink manager

### Installing GNU Stow

#### macOS
```bash
brew install stow
```

#### Debian/Ubuntu
```bash
sudo apt-get install stow
```

#### Fedora
```bash
sudo dnf install stow
```

## Installation

1. Clone this repository to your home directory:
```bash
git clone https://github.com/skalidindi/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

2. Run the stow script to create symlinks:
```bash
./stow.sh
```

This will create symlinks for all configuration files in your home directory.

### Installing Individual Configurations

If you only want to install specific configurations, you can use stow directly:

```bash
stow -t ~/ -R bash  # Only install bash configuration
stow -t ~/ -R nvim  # Only install nvim configuration
```

## Customization

### Bash/Zsh Configuration

The bash and zsh configurations are organized into separate files:
- `.aliases` - Command aliases
- `.exports` - Environment variables
- `.functions` - Shell functions
- `.path` - PATH modifications

### Git Configuration

The git configuration includes separate files for different contexts:
- `gitconfig` - Main git configuration
- `oss.gitconfig` - Configuration for open source projects
- `work.gitconfig` - Configuration for work projects

## Updating

To update your dotfiles after making changes:

```bash
./stow.sh
```

## License

This project is open source and available under the [MIT License](LICENSE).
