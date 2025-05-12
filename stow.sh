STOW_DIRS=( aerospace alacritty bash bat bin btop fastfetch gh ghostty git kitty lazygit misc nvim skhd tmux yazi zellij zsh )
for i in "${STOW_DIRS[@]}"
do
	stow -t ~/ -R "$i"
done
