{lib, ...}: {
  programs.bash = {
    bashrcExtra = lib.mkAfter ''
      export SHELL="/opt/homebrew/bin/bash"
      export CLICOLOR=1
      export LSCOLORS=GxFxCxDxBxegedabagaced
      PATH=/opt/homebrew/bin:$PATH
    '';
  };
}
