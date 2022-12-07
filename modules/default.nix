{config, pkgs, ... }:
{
  imports = [
    ./mimetype
    ./clipkgs
    ./systemd
    ./host_specific
  ];
}
