STOW_DIRS=( alacritty bash bin git kitty misc nvim skhd tmux yabai zsh )
for i in "${STOW_DIRS[@]}"
do
	stow -R "$i"
done
