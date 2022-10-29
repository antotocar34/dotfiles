{ pkgs }:

with pkgs.lib;
let
  getBinName = x: x.meta.mainProgram or (getName x) ;
in
{
wrapWithNixGL = nixGL: pkg:
   pkgs.writeShellApplication {
    name = pkg.pname;

    runtimeInputs = [];

    text = ''
      exec ${nixGL}/bin/nixGLIntel ${getExe pkg} "$@"
    '';
    };
}
