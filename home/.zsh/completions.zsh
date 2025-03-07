autoload -Uz compinit
if [ -z "$ZSH_COMPDUMP" ]; then
  ZSH_COMPDUMP="${ZDOTDIR:-$HOME}/.zcompdump"
fi
compinit -d "${ZSH_COMPDUMP}"

if command -v ng &>/dev/null; then
  source <(ng completion script)
fi

if [ -f ~/.zcompdump ]; then
  zcompdump_cache=~/.zcompdump.zwc
  if [ ! -f "$zcompdump_cache" ] || [ ~/.zcompdump -nt "$zcompdump_cache" ]; then
    zcompile ~/.zcompdump
  fi
fi
