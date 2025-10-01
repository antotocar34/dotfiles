{
  config,
  pkgs,
  ...
}: 
let l = pkgs.lib // builtins;
in
{
  config.services.skhd = {
    enable = true;
    config = 
    let
      focus = name: "/usr/bin/env osascript -e 'tell application \"${name}\" to activate'";
      applicationShortcut = 
        name: shortcut: "${shortcut} : ${focus name} || /usr/bin/env open -a ${name}";
    in
    ''
      ${applicationShortcut "kitty" "shift + cmd - return"}
      ${applicationShortcut "Slack" "shift + ctrl - s"}
    '';
    # This is what I had before but it keeps opening new terminals and it's a bit much
    # shift + cmd - return : /usr/bin/env osascript -e 'tell application "Kitty" to activate' || /usr/bin/env open -a kitty
  };
}

