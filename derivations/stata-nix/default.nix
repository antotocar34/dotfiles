with import <nixpkgs> {}; 

stdenv.mkDerivation rec {
  name = "stata";
  version = "69.69" ;

  buildPhase = false;
  dontConfigure = true;
  dontBuild = true;

  unpackPhase = "true";
  installPhase = ''
    mkdir -p $out/
    cp -r ${./stata/stata14} $out/
    mkdir -p $out/
    cp -r ${./stata/png-fix} $out/
  '';
  postFixup = 
  let 
  libPath = lib.makeLibraryPath [ 
                                  glib 
                                  glibc
                                  fontconfig
                                  libpng12
                                  cairo
                                  gnome2 .pango
                                  gdk_pixbuf
                                  atk
                                  gtk2-x11
                                  gcc-unwrapped
                                ] ;
  in
  ''
    statadir=$(basename ${./stata/stata14})
    pngfixdir=$(basename ${./stata/png-fix})

    patchelf \
      --set-interpreter "$(cat ${binutils}/nix-support/dynamic-linker)" \
      --set-rpath "${libPath}" \
        $out/$statadir/xstata-mp

    mkdir $out/bin
    ln -s $out/$statadir/xstata-mp $out/bin/xstata-mp

    # sed -i "s#~\/local\/stata#$out\/$statadir#" $out/$pngfixdir/stata-png-fixed.sh
    # sed -i "s#~\/local\/bin#$out\/bin#" $out/$pngfixdir/compile-stata-png-fix.sh
    # sed -i "s#~\/local\/stata-png-fix#$out\/$pngfixdir#" $out/$pngfixdir/compile-stata-png-fix.sh
    # bash $out/$pngfixdir/compile-stata-png-fix.sh
  '';
}
