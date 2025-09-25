
BUG:
antoine.carnec@LONLTMC773WR0 ~/RustroverProjects/rbw (main)
λ which -a fd
/Users/antoine.carnec/.nix-profile/bin/fd
/Users/antoine.carnec/.nix-profile/bin/fd
antoine.carnec@LONLTMC773WR0 ~/RustroverProjects/rbw (main)
λ nix shell nixpkgs#fd
antoine.carnec@LONLTMC773WR0 ~/RustroverProjects/rbw (main)
λ which -a fd
/Users/antoine.carnec/.nix-profile/bin/fd
/nix/store/glkzsfqgjp9bx6hia74abfqa9wsczfx7-fd-10.3.0/bin/fd
/Users/antoine.carnec/.nix-profile/bin/fd
/Users/antoine.carnec/.nix-profile/bin/fd

EXPECTED_BEHAVIOUR:
the command I have jsut nix shelled would be at the top of my path

FIX:
Initialization in `homedir/.bashrc` now appends persistent PATH entries instead of
prepending them, so temporary environments such as `nix shell` stay at the
front of `$PATH`.
