{ inputs, ... }:
{
  flake.modules.homeManager.home = import ../_common/home.nix;
}
