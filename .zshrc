# ── FZF ───────────────────────────────────────────────────────────────
source <(fzf --zsh)

# ── VI MODE ───────────────────────────────────────────────────────────
bindkey -v
export KEYTIMEOUT=1
bindkey '^?' backward-delete-char

# Vi mode navigation bindings for history substring search
# (Allows Up/Down or k/j arrows to search through history)
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
bindkey '^R' fzf-history-widget

# ── COMPLETIONS ───────────────────────────────────────────────────────
autoload -Uz compinit && compinit
zstyle ':completion:*' menu no
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':fzf-tab:*' fzf-flags '-i'
zstyle ':fzf-tab:*' fzf-preview 'eza -1 --icons --color=always $realpath'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --tree --level=2 --color=always $realpath'

# ── ANTIDOTE ──────────────────────────────────────────────────────────
[[ -d ~/.antidote ]] || git clone --depth=1 https://github.com/mattmc3/antidote.git ~/.antidote
source ~/.antidote/antidote.zsh
antidote load

# ── INIT ──────────────────────────────────────────────────────────────
command -v starship &>/dev/null && eval "$(starship init zsh)"
command -v zoxide   &>/dev/null && eval "$(zoxide init zsh)"
eval $(thefuck --alias tfk)

# ── HISTORY ───────────────────────────────────────────────────────────
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE

# ── ALIASES ───────────────────────────────────────────────────────────
alias cat="bat -pp" less="bat --paging=always"
alias pingu="ping -c5 google.com"
alias v=nvim vim=nvim :q=exitherdr 
alias ..="cd .." ...="cd ../.."
alias h=herdr hs="herdr session list" hks="herdr session stop"
ta() {
    tmux new-session -A -s "${1:-$(basename "$PWD")}"
}
alias tls='tmux ls' tks='tmux kill-session'
alias mof="niri msg output HDMI-A-1 off" mon="niri msg output HDMI-A-1 on"
alias ls='eza --color=always --group-directories-first --icons'
alias ll='eza -la --icons --octal-permissions --group-directories-first'
alias l='eza -bGF --header --git --color=always --group-directories-first --icons'
alias llm='eza -lbGd --header --git --sort=modified --color=always --group-directories-first --icons' 
alias la='eza --long --all --group --group-directories-first'
alias lx='eza -lbhHigUmuSa@ --time-style=long-iso --git --color-scale --color=always --group-directories-first --icons'

alias lS='eza -1 --color=always --group-directories-first --icons'
alias lt='eza --tree --level=2 --color=always --group-directories-first --icons'
alias l.="eza -a | grep -E '^\.'"

# ── BANNER ────────────────────────────────────────────────────────────
command -v fastfetch &>/dev/null && fastfetch

# ── PATH ──────────────────────────────────────────────────────────────
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/go/bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.bun/bin"
export PATH="$PATH:$HOME/.npm-packages/bin"
export PATH="$PATH:$HOME/scripts"
export PATH="$PATH:/opt/lampp/bin"
# little-coder
export LLAMACPP_API_KEY=noop
export LLAMACPP_BASE_URL=http://localhost:8080/v1
