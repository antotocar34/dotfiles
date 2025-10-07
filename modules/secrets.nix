{inputs, ...}:
{

  flake.modules.homeManager.secrets = {config, pkgs, system, ...}: {
    imports = [
      "${inputs.dotfiles-private}/modules/gh"
      "${inputs.dotfiles-private}/modules/ssh"
      "${inputs.dotfiles-private}/modules/secrets"
      inputs.agenix.homeManagerModules.default
    ];

    home.packages = [
      inputs.agenix.packages."${system}".agenix
    ];
  };

  flake.modules.homeManager.work = {system, ...}: {
    imports = [
      "${inputs.dotfiles-private}/modules/work"
    ];
  };
}
