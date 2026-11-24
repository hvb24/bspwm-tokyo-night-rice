# bspwm-tokyo-night-rice shell additions. Each line only activates when its tool is installed.
command -v starship >/dev/null && eval "$(starship init zsh)"
command -v zoxide   >/dev/null && eval "$(zoxide init zsh)"
command -v eza      >/dev/null && alias ls='eza --icons --group-directories-first' && alias ll='eza -l --icons --git --group-directories-first'
command -v bat      >/dev/null && alias cat='bat --paging=never --style=plain'
