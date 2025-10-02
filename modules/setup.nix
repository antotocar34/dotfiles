{ inputs, pkgs, lib, ... }:
{
  imports = [ 
    inputs.flake-parts.flakeModules.modules 
    inputs.home-manager.flakeModules.home-manager
  ];
}
