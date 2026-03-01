autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
export LS_COLORS="di=1;34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

###
# Theme
###
eval "$(starship init zsh)"

###
# Zsh Autosuggestions
###
source $HOME/.nix-profile/share/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8' # Subtle gray shadow
ZSH_AUTOSUGGEST_IGNORE_WIDGETS+=(smart-tab)

###
# Fuzzy Finder (CTRL + R) fzf history search
###
source <(fzf --zsh)

###
# Zsh Configs
###

# History
HISTFILE=$ZDOTDIR/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY

###
# Keybindings
###

# Tab
smart-tab() {
    if [[ -n "$POSTDISPLAY" ]]; then
        # If there's a shadow, accept it
        zle autosuggest-accept
    else
        # If no shadow, open the completion menu (grid)
        zle expand-or-complete
    fi
}
zle -N smart-tab
bindkey '^I' smart-tab

# Right arrow
smart-right-arrow() {
    if [[ $#BUFFER -eq $CURSOR ]]; then
        # If at end of line, open the completion menu
        zle expand-or-complete
    else
        # If in middle of text, just move cursor right
        zle forward-char
    fi
}
zle -N smart-right-arrow
bindkey '^[[C' smart-right-arrow

# Ctrl + Left Arrow: Move back one word
bindkey '^[[1;5D' backward-word
# Ctrl + Right Arrow: Move forward one word
bindkey '^[[1;5C' forward-word
# Ctrl + Backspace: Delete one word backward
bindkey '^H' backward-kill-word
# Fix the standard Delete key (so it doesn't print ~)
bindkey '^[[3~' delete-char
# Ctrl + Delete: Delete one word forward
bindkey '^[[3;5~' kill-word
# Home: Move to beginning of line
bindkey '^[[H' beginning-of-line
bindkey '^[OH' beginning-of-line
# End: Move to end of line
bindkey '^[[F' end-of-line
bindkey '^[OF' end-of-line
# Stop at every slash (/), dot (.), or underscore (_)
autoload -U select-word-style
select-word-style bash

###
# Aliases
###
alias ls='eza --icons --group-directories-first'
alias cat='bat --style="plain"'
alias sudo='sudo ' # Allows aliases to work with sudo
alias lst='ls --tree'
alias stowhome='stow -t ~ '

###
# Initialize Nix
###
if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then
  source ~/.nix-profile/etc/profile.d/nix.sh
fi
