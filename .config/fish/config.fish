set -g fish_greeting

function fish_greeting
echo '
███████╗██╗   ██╗███╗   ███╗██╗████████╗
██╔════╝██║   ██║████╗ ████║██║╚══██╔══╝
███████╗██║   ██║██╔████╔██║██║   ██║   
╚════██║██║   ██║██║╚██╔╝██║██║   ██║   
███████║╚██████╔╝██║ ╚═╝ ██║██║   ██║   
╚══════╝ ╚═════╝ ╚═╝     ╚═╝╚═╝   ╚═╝   
'
	fastfetch
end

if status is-interactive
    # Commands to run in interactive sessions can go here
end

starship init fish | source

set aurhelper paru

# List Directory
alias c='clear'
alias l='eza -lh --icons=auto'
alias ls='eza -1 --icons=auto'
alias ll='eza -lha --icons=auto --sort=name --group-directories-first'
alias ld='eza -lhD --icons=auto'
alias lt='eza --icons=auto --tree'
alias un='$aurhelper -Rns'
alias up='$aurhelper -Syu'
alias pl='$aurhelper -Qs'
alias pa='$aurhelper -Ss'
alias pc='$aurhelper -Sc'
alias po='$aurhelper -Qtdq | $aurhelper -Rns -'
alias vc='code'

# Directory navigation shortcuts
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'
