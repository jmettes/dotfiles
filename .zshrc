# jump words ctrl+arrow correctly
bindkey '^[[1;5C' emacs-forward-word
bindkey '^[^[[D' emacs-backward-word

# command for versioning dotfiles
alias config='git --git-dir=$HOME/.cfg --work-tree=$HOME'
