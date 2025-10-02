{inputs, ...}:
{
  flake.modules.homeManager.cli = {pkgs, system, ...}: 
  let
    myNvim = inputs.my-neovim.packages.${system}.neovim;
  in
  {
    home.sessionVariables = {
      EDITOR = "${myNvim}/bin/nvim";
    };

    home.packages = [myNvim];
  };
}
