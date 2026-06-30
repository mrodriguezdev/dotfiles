# Better ls
alias ls='eza --header --icons --group-directories-first'
alias ll='eza -lh --header --icons --group-directories-first'
alias la='eza -lah --header --icons --group-directories-first'

# Tree
alias tree='eza --tree --icons'
alias lt='eza --tree --level=2 --icons'

# Git status in listings
alias lg='eza -lh --header --icons --git --group-directories-first'

# Better cat
alias cat='bat'