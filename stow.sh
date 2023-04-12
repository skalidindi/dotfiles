STOW_DIRS=( alacritty bash bin git misc nvim tmux yabai zsh )
for i in "${STOW_DIRS[@]}"
do
	stow -R "$i"
done
