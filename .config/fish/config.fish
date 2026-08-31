if status is-interactive
    # Vim keybindings
    fish_vi_key_bindings 
    
    # fzf integration
    command -v fzf &> /dev/null && fzf --fish | source 

    # fzf integration
    command -v thefuck &> /dev/null && thefuck --alias fk | source

    # Starship custom prompt
    command -v starship &> /dev/null && starship init fish | source

    # Direnv + Zoxide
    command -v direnv &> /dev/null && direnv hook fish | source
    command -v zoxide &> /dev/null && zoxide init fish --cmd cd | source

    # Better ls
    command -v eza &> /dev/null && alias ls='eza --color=always --group-directories-first --icons'
    command -v nvim &> /dev/null &&  alias vim='nvim' 
    command -v bat &> /dev/null && { alias cat='bat -pp'; alias less='bat --paging=always'; }


    # Path
    fish_add_path ~/.local/bin
    fish_add_path ~/.cargo/bin
    fish_add_path ~/go/bin
    fish_add_path ~/.bun/bin
    fish_add_path ~/.npm-packages/bin
    fish_add_path ~/opt/lampp/bin

    # Vars
    set -gx EDITOR nvim
    set -gx VISUAL nvim
    set -gx LLAMACPP_API_KEY noop
    set -gx LLAMACPP_BASE_URL http://localhost:8080/v1

    # Abbrs
    abbr v 'vim'
    abbr lg 'lazygit'
    abbr gd 'git diff'
    abbr ga 'git add .'
    abbr gc 'git commit -am'
    abbr gl 'git log'
    abbr gs 'git status'
    abbr gst 'git stash'
    abbr gsp 'git stash pop'
    abbr gp 'git push'
    abbr gpl 'git pull'
    abbr gsw 'git switch'
    abbr gsm 'git switch main'
    abbr gb 'git branch'
    abbr gbd 'git branch -d'
    abbr gco 'git checkout'
    abbr gsh 'git show'

    abbr l 'ls'
    abbr ll 'ls -l'
    abbr la 'ls -a'
    abbr lla 'ls -la'
    abbr tree 'eza --tree --long --all --group --group-directories-first'

    abbr c 'clear'
    abbr herdr 'herdr'
    abbr hs 'herdr session list'
    abbr hks 'herdr session stop'
    abbr h 'history'

    abbr pingu 'ping -c5 google.com'
    abbr tls 'tmux ls'
    abbr tks 'tmux kill-session'
    abbr mof 'niri msg output HDMI-A-1 off'
    abbr mon 'niri msg output HDMI-A-1 on'

end
