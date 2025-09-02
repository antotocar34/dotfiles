{
  config,
  pkgs,
  ...
}: let l = pkgs.lib // builtins;
in {
  imports = [
    ./mimetype
    ./clipkgs
    ./guipkgs
    ./systemd
    ./host_specific
    ./imp
    ./scripts
    # ./plasma
    ./productivity
    ./nix
  ];
}
