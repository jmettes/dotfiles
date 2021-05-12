# jump words ctrl+arrow correctly
bindkey '^[[1;5C' emacs-forward-word
bindkey '^[^[[D' emacs-backward-word

# command for versioning dotfiles
alias config='git --git-dir=$HOME/.cfg --work-tree=$HOME'

export PATH=$PATH:~/go/bin/
export PATH=$PATH:~/.local/bin
export PATH=$PATH:$HOME/bin/

# added by travis gem
[ -f /home/jonathan/.travis/travis.sh ] && source /home/jonathan/.travis/travis.sh

# make conda work
. /home/jonathan/.conda/etc/profile.d/conda.sh


alias ssh='TERM=xterm ssh -o ServerAliveInterval=60 -o SendEnv=TERM'

# fzf
if [ -n "${commands[fzf-share]}" ]; then
  source "$(fzf-share)/key-bindings.zsh"
  source "$(fzf-share)/completion.zsh"
fi
