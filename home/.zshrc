if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

for file in ~/.zsh/*.zsh; do
  [ -r "$file" ] && source "$file"
done

if [ -f ~/.p10k.zsh ]; then
  source ~/.p10k.zsh
fi
