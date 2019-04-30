with import <nixpkgs> {};

vim_configurable.customize {
    name = "vi";
    vimrcConfig.customRC = ''
        set expandtab ts=4 sw=4 ai
        set mouse=r
        syntax enable
        colorscheme solarized
        set incsearch hlsearch
        set nowrap

        " fix backspace
        " https://vi.stackexchange.com/questions/2162/why-doesnt-the-backspace-key-work-in-insert-mode
        set backspace=indent,eol,start

        " make vim-signify gutter background color less ugly
        highlight DiffAdd cterm=bold ctermbg=none
        highlight clear SignColumn
        highlight clear LineNr
    '';

    # Use the default plugin list shipped with nixpkgs
    vimrcConfig.vam.knownPlugins = pkgs.vimPlugins;
    vimrcConfig.vam.pluginDictionaries = [
        { names = [
            "vim-signify"
        ]; }
    ];
}
