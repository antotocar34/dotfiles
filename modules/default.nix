{
  config,
  pkgs,
  ...
}: let l = pkgs.lib // builtins;
in {
  # Basic config options

  imports = [
    ./mimetype
    ./clipkgs
    ./guipkgs
    ./systemd
    ./host_specific
    ./imp
    ./scripts
    ./true_aliases
    ./productivity
    ./nix
    ./secrets
  ];
}
