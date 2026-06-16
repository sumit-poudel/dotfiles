# ── PATH ──────────────────────────────────────────────────────────────
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.bun/bin:$PATH"
export PATH="$PATH:/opt/lampp/bin"

# ── VI MODE ───────────────────────────────────────────────────────────
bindkey -v
export KEYTIMEOUT=1
bindkey '^?' backward-delete-char

# Vi mode navigation bindings for history substring search
# (Allows Up/Down or k/j arrows to search through history)
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# ── COMPLETIONS ───────────────────────────────────────────────────────
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# ── ANTIDOTE ──────────────────────────────────────────────────────────
[[ -d ~/.antidote ]] || git clone --depth=1 https://github.com/mattmc3/antidote.git ~/.antidote
source ~/.antidote/antidote.zsh
antidote load

# ── INIT ──────────────────────────────────────────────────────────────
command -v starship &>/dev/null && eval "$(starship init zsh)"
command -v zoxide   &>/dev/null && eval "$(zoxide init zsh)"

# ── HISTORY ───────────────────────────────────────────────────────────
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE

# ── ALIASES ───────────────────────────────────────────────────────────
alias pg="ping -c5 google.com"
alias v=nvim vim=nvim :q=exit
alias ..="cd .." ...="cd ../.."
alias t=tmux ta="tmux attach" ts="tmux ls" tks="tmux kill-session"
alias mf="niri msg output HDMI-A-1 off" mo="niri msg output HDMI-A-1 on"

# ── BANNER ────────────────────────────────────────────────────────────
command -v fastfetch &>/dev/null && fastfetch
