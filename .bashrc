eval `dircolors ~/.dircolors`
export EDITOR=vim
# sudo mount -t vboxsf shared_folder ~/shared_folder/

# https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/
alias config='git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
