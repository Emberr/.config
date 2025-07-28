# Fish shell configuration
#
# This file defines aliases, environment variables and integrates
# Pywal colours into the terminal session.  It also initialises
# Starship if installed.

# Load Pywal escape sequences if available (colours in shells)
if test -f ~/.cache/wal/sequences
    cat ~/.cache/wal/sequences
end

# Aliases for convenience
alias ll='ls -lah'
alias la='ls -A'
alias update='sudo pacman -Syu'
alias btop='btop'
alias gotop='gotop'

# Set default editor
set -x EDITOR code

# Use starship prompt if installed
if type -q starship
    starship init fish | source
end