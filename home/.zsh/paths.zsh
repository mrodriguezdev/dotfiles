# Remove duplicate PATH entries
typeset -U path PATH

# User binaries
path=(
  "$HOME/.local/bin"
  "$HOME/bin"
  /usr/local/bin
  $path
)

export PATH

# SDKMAN
if [[ -d "$HOME/.sdkman" ]]; then
  export SDKMAN_DIR="$HOME/.sdkman"
  [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
fi

# NVM
if [[ -d "$HOME/.nvm" ]]; then
  export NVM_DIR="$HOME/.nvm"
  [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
  [[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"
fi