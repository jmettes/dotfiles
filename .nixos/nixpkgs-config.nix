{
  allowUnfree = true;

#  chromium = {
#    enablePepperFlash = true;
#  };

#  firefox = {
#    enableGoogleTalkPlugin = true;
#    enableAdobeFlash = true;
#  };

  packageOverrides = super: let self = super.pkgs; in with self; rec {

    systemToolsEnv = with super; buildEnv {
        name = "systemToolsEnv";
        paths = [
            atom
            evince
            file
            gcc
            git
            gnumake
            goldendict
            inetutils
            jetbrains.idea-community
            jetbrains.pycharm-community
            slack
            escrotum
            maim
            notify-osd
            octaveFull
            tree
            unzip
            vscode
            wget
            which
            xclip
            zip
        ];
    };


    pythonEnv = with super; buildEnv {
        name = "pythonEnv";
        paths = [
            python3
        ];
    };

  };
}
