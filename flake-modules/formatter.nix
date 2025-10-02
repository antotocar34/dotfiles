{ inputs, pkgs, ... }:
{
  flake.perSystem.formatter = pkgs.nixfmt-tree;
}

