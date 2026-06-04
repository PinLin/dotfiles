[ -f /etc/bashrc ] && . /etc/bashrc

PS1='\[\e[0;96m\]\u\[\e[0m\]@\[\e[0;92m\]\h\[\e[0m\]:\[\e[0;93m\]\w\[\e[0m\]$ '
[ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"

# Cross-shell helpers
[ -f ~/.shell_helpers ] && source ~/.shell_helpers

# Machine-local overrides
[ -f ~/.bashrc.local ] && source ~/.bashrc.local
