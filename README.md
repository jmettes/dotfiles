https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/

## Setup

Setup NixOS configuration files:

```
$ sudo ln -s ${HOME}/.nixos/configuration.nix /etc/nixos/configuration.nix
$ sudo ln -s ${HOME}/.nixos/hardware-configuration.nix /etc/nixos/hardware-configuration.nix
$ sudo ln -s ${HOME}/.nixos/nixpkgs-config.nix /etc/nixos/nixpkgs-config.nix
```

## Usage

Just replace `git` with `config`:

```
$ cd ~
$ config add <my changed dot files>
$ config commit -m "update"
$ config push origin master
```

## todo

- reorganise dotfiles to be configured through nix
