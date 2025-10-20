{
  flake.lib = {
    wrapWithNixGL =
      pkgs: nixGL: pkg:
      pkgs.writeShellApplication {
        name = pkg.pname;

        runtimeInputs = [ ];

        text = ''
          exec ${nixGL}/bin/nixGL ${pkgs.lib.getExe pkg} "$@"
        '';
      };
    wrapWithNixGLFull =
      pkgs: nixGL: pkg:
      pkgs.runCommand "${pkg.name}-nixgl-wrapper" { } ''
        mkdir $out
        ln -s ${pkg}/* $out
        rm $out/bin
        mkdir $out/bin
        for bin in ${pkg}/bin/*; do
         wrapped_bin=$out/bin/$(basename $bin)
         echo "exec ${nixGL}/bin/nixGL $bin \$@" > $wrapped_bin
         chmod +x $wrapped_bin
        done
      '';
  };
}
