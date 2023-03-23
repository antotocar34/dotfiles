{
  config,
  pkgs,
  ...
}: let l = pkgs.lib // builtins;
in {
  # Basic config options

  options = {
    home_config = l.mkOption {
      type = l.types.str;
      description = "Path to configuration home";
    };
  };

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
