# Ensure a UTF-8 locale. macOS <26 doesn't set one (Apple added a C.UTF-8
# fallback to /etc/zprofile only in macOS 26); without it, an ssh/tmux session
# that doesn't get LANG forwarded falls back to US-ASCII and p10k/powerline breaks.
# Use en_US.UTF-8 — C.UTF-8 is not a valid locale on older macOS (<26).
[ -z "$LANG" ] && export LANG=en_US.UTF-8

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Zsh built-in options
setopt HIST_IGNORE_ALL_DUPS
bindkey -e
WORDCHARS=${WORDCHARS//[\/]}

# Zim module config
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# Zim plugin manager: auto-bootstrap on first run, re-init when .zimrc changes
ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  if (( ${+commands[curl]} )); then
    curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  else
    mkdir -p ${ZIM_HOME} && wget -nv -O ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  fi
fi
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  source ${ZIM_HOME}/zimfw.zsh init -q
fi
source ${ZIM_HOME}/init.zsh

# zsh-history-substring-search: bind ^[[A/^[[B for both pre/post zle-line-init
zmodload -F zsh/terminfo +p:terminfo
for key ('^[[A' '^P' ${terminfo[kcuu1]}) bindkey ${key} history-substring-search-up
for key ('^[[B' '^N' ${terminfo[kcud1]}) bindkey ${key} history-substring-search-down
for key ('k') bindkey -M vicmd ${key} history-substring-search-up
for key ('j') bindkey -M vicmd ${key} history-substring-search-down
unset key

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Cross-shell helpers (getpass etc.)
[ -f ~/.shell_helpers ] && source ~/.shell_helpers

# Machine-specific config (NOT tracked - SDK paths, secrets, etc.)
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
