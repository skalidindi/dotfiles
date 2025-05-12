STOW_DIRS=( bash bat bin btop fastfetch gh ghostty git kitty lazygit misc nvim tmux yazi zellij zsh )
for i in "${STOW_DIRS[@]}"
do
	stow -t ~/ -R "$i"
done
