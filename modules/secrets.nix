{inputs, ...}:
{
  flake.modules.homeManager.secrets = {system, ...}: {
    imports = [
      # (inputs.import-tree "${inputs.dotfiles-private}/modules")
      "${inputs.dotfiles-private}/modules"
      inputs.agenix.homeManagerModules.default
    ];

    home.packages = [
      inputs.agenix.packages."${system}".agenix
    ];
  };
}
