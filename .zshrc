#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Time startup
start=$(gdate +%s.%N)

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...

# Execute bash_profile
source ~/.bash_profile

# Overwrite Prezto defaults (Live dangerously)
unalias rm
unalias cp
unalias mv

# jEnv
jenv() {
  unset -f jenv
  PATH="$HOME/.jenv/bin:$PATH"
  eval "$(command jenv init -)"
  jenv "$@"
}

# Nvm
nvm() {
  unset -f nvm
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm
  nvm "$@"
}

# Anaconda
export PATH="/anaconda3/bin:$PATH"

# rbenv
rbenv() {
  unset -f rbenv
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(command rbenv init -)"
  rbenv "$@"
}

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# End time startup
end=$(gdate +%s.%N)
runtime=$(python -c "print(${end} - ${start})")
#echo "Runtime was $runtime"
