alias config='git --git-dir=$HOME/.cfg --work-tree=$HOME'
alias ls='ls -p --color=auto'

export PATH=~/bin:$PATH

source ~/.bash_profile

# enable horizontal scrolling with shift + vertical scroll
# https://askubuntu.com/questions/404737/horizontal-scrolling-in-firefox-to-shiftmouse-scroll-instead-of-back-forward
# also needs xbindkeys and xautomation installed
xbindkeys

# disable "accessibility bus address" warning on startup of emacs
# https://github.com/NixOS/nixpkgs/issues/16327
export NO_AT_BRIDGE=1

## libinput acceleration
## https://gist.github.com/tbranyen/0eb89e8e2517d9205b0fe33127e6cb5c
#touchpad_id=$(xinput --list | grep "TouchPad" | xargs -n 1 | grep "id=" | sed 's/id=//g')
#accel_speed_code=$(xinput --list-props $touchpad_id | awk '/Accel Speed \(/ {print $4}' | grep -o '[0-9]\+')
## Default acceleration is too slow (non-existent)
#xinput --set-prop $touchpad_id $accel_speed_code .75
