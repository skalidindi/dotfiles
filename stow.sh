STOW_DIRS=( aerospace alacritty bash bat bin btop fastfetch gh git kitty misc nvim skhd tmux zsh )
for i in "${STOW_DIRS[@]}"
do
	stow -t ~/ -R "$i"
done
