{ pkgs, ... }:
{ 
  programs.plasma = import ../../homedir/.config/plasma-settings/plasma_settings.nix; 
}
