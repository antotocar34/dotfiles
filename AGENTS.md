Your mission is to refactor my nix config, using the dendritic pattern, which is documented in .ai/DENDRITIC.md.

Please follow that. And test as you go with the `just build` command. This is a fresh git branch so go wild, and commit along the way when you need it. Don't worry about the private submodule (flake input: dotfiles-private right now). I'll take care of that later.

Please do the migration gradually, starting with basic configs. And start only by migrating my macbookpro please.

Oh and please follow the philosophy that most modules are features, while then the hosts consume those features.


## REMEMBER
Whenever you add a new file, remember to git add it so that it's picked up the nix flake
