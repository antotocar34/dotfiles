{
  flake.modules.homeManager.cli =
    {
      pkgs,
      lib,
      host,
      ...
    }:
    {
      programs.bash = {
        enable = true;
        enableCompletion = true;
        profileExtra = lib.readFile ../homedir/.extra_profile;
        initExtra = lib.readFile ../homedir/.bashrc;
        bashrcExtra = lib.mkAfter (
          ''
            . <(cat ${../homedir/.config/bash_shortcuts}/*.bash)
          ''
          + lib.optionalString pkgs.stdenv.isDarwin ''
            # export SHELL="/opt/homebrew/bin/bash"
            export CLICOLOR=1
            export LSCOLORS=GxFxCxDxBxegedabagaced
            PATH=/opt/homebrew/bin:$PATH
          ''
        );
      };

      home.sessionVariables = {
        SHELL = "${pkgs.bash}/bin/bash";
        CLI_SYMBOL = host.extras.symbol;
      };
    };
}
