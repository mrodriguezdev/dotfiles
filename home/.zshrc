# Instant prompt de Powerlevel10k
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source ~/.zsh/envs.zsh
source ~/.zsh/paths.zsh
source ~/.zsh/completions.zsh
source ~/.zsh/plugins.zsh
source ~/.zsh/aliases.zsh
source ~/.zsh/powerlevel10k.zsh