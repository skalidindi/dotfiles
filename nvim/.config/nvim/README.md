# Neovim

LazyVim-based Neovim config managed by the top-level dotfiles bootstrap.

## Install

```bash
stow -t "$HOME" -R nvim
```

The normal path is still:

```bash
./bootstrap.sh
```

## Layout

- `init.lua` - starts the LazyVim config.
- `lazyvim.json` - enabled LazyVim extras.
- `lazy-lock.json` - plugin lockfile.
- `lua/config/` - local options, keymaps, autocmds, and Lazy setup.
- `lua/plugins/` - local plugin overrides and additions.
- `stylua.toml` - Lua formatting config.

## Maintenance

Use LazyVim's normal plugin workflow inside Neovim:

```vim
:Lazy
:Lazy sync
```

For a cheap headless sanity check:

```bash
nvim --headless "+checkhealth" "+qa"
```
