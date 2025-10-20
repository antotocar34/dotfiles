{ inputs, lib, ... }:
{
  perSystem =
    {
      pkgs,
      config,
      ...
    }:
    {
      formatter = pkgs.nixfmt-tree;
    };
}
