function fish_user_key_bindings
    fish_vi_key_bindings

    bind -M normal k history-search-backward
    bind -M normal j history-search-forward
end
