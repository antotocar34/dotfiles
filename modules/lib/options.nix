{ lib, ... }:
let
  t = lib.types;
in
{
  options.flake.lib = lib.mkOption {
    type = t.attrsOf (t.functionTo t.anything);
  };
}
