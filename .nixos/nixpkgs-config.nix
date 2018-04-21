{
  allowUnfree = true;

  chromium = {
    enablePepperFlash = true;
  };

  firefox = {
    enableGoogleTalkPlugin = true;
    enableAdobeFlash = true;
  };

  packageOverrides = super: let self = super.pkgs; in with self; rec {

    systemToolsEnv = with super; buildEnv {
        name = "systemToolsEnv";
        paths = [
            file
            gcc
            git
            gnumake
            goldendict
            inetutils
            slack
            maim
            tree
            unzip
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
