{ config, lib, ... }:
{
  options.info = lib.mkOption { type = lib.types.attrsOf lib.types.str; };

  config.info = {
    email = "antoinecarnec@gmail.com";
    name = "Antoine Carnec";
  };
}
