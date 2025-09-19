{pkgs}:
import ./nixgl.nix {inherit pkgs;} //
{
  mkGhModule = { name, secretFile }:
  { pkgs, lib, ... }:
    let
      wrapper = pkgs.writeShellScriptBin name ''
        set -euo pipefail
        export GH_CONFIG_DIR="$(mktemp -d)"
        trap 'rm -rf "$GH_CONFIG_DIR"' EXIT
        cat "${secretFile}" > "$GH_CONFIG_DIR/hosts.yml"
        exec ${pkgs.gh}/bin/gh "$@"
      '';
    in {
      home.packages = [ wrapper ];
      programs.bash.initExtra = lib.mkAfter ''
        . ${pkgs.gh}/share/bash-completion/completions/gh.bash
        if type -t __start_gh &>/dev/null; then
          complete -F __start_gh ${name}
        fi
      '';
    };
}
