{ pkgs, ... }:
let
  l = pkgs.lib // builtins;
  focus = name: "/usr/bin/env osascript -e 'tell application \"${name}\" to activate'";
  applicationShortcut = name: shortcut: "${shortcut} : ${focus name} || /usr/bin/env open -a ${name}";
in {
  services.skhd = {
    enable = true;
    config = ''
      ${applicationShortcut "kitty" "shift + cmd - return"}
      ${applicationShortcut "Slack" "shift + ctrl - s"}
    '';
  };
}
