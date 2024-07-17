STOW_DIRS=( alacritty bash bat bin btop fastfetch gh git kitty misc nvim skhd tmux yabai zsh )
for i in "${STOW_DIRS[@]}"
do
	stow -t ~/ -R "$i"
done
