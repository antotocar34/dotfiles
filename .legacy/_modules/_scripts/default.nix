{
  pkgs,
  lib,
  ...
}:
{
  home.packages = [
    (pkgs.writeShellScriptBin "find_" (lib.readFile ./find_))
  ];
}
