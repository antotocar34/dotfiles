{ inputs, ... }:
{
  flake.modules.homeManager.context = { ... }: {
    config._module.args.inputs = inputs;
  };
}
