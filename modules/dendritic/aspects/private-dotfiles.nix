{ inputs, ... }:
{
  flake.modules.homeManager."private-dotfiles" = { ... }: {
    imports = [ "${inputs.dotfiles-private}/modules" ];
  };
}
