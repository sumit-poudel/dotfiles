# Setup Zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# ── Must come BEFORE fzf-tab ──────────────────────────────────────
autoload -Uz compinit
compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
setopt NO_CASE_GLOB
# ─────────────────────────────────────────────────────────────────

# Plugins
zinit load zdharma-continuum/history-search-multi-word
zinit ice wait lucid
zinit light zsh-users/zsh-completions
zinit light Aloxaf/fzf-tab          # now compinit is already done
zinit light zsh-users/zsh-autosuggestions
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light MichaelAquilina/zsh-you-should-use
zi ice has'eza' atinit'AUTOCD=1'
zi light z-shell/zsh-eza
zinit ice depth=1
zinit light jeffreytse/zsh-vi-mode

# Starship
export STARSHIP_DISABLE_KEYMAP_HOOK=true
zinit ice as"command" from"gh-r" \
          atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
          atpull"%atclone" src"init.zsh"
zinit light starship/starship

# Zoxide
zinit ice wait"2" as"command" from"gh-r" lucid \
  mv"zoxide*/zoxide -> zoxide" \
  atclone"./zoxide init zsh > init.zsh" \
  atpull"%atclone" src"init.zsh" nocompile'!'
zinit light ajeetdsouza/zoxide

# Oh-My-ZSH plugins
zinit snippet OMZP::git
zinit snippet OMZP::extract

# Run zinit's compinit wrapper after all plugins settle
zinit cdreplay -q

# History
HISTFILE="${HOME}/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE

# Alias
alias pg="ping -c5 google.com"

# Fastfetch banner
if command -v fastfetch >/dev/null; then
    cat <<'SUMIT'
                  _ __
  ___ __ ____ _  (_) /_
 (_-</ // /  ' \/ / __/
/___/\_,_/_/_/_/_/\__/
SUMIT
    fastfetch
fi
