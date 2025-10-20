{ inputs, ... }:
{
  flake.modules.homeManager.cli =
    { pkgs, system, ... }:
    let
      myNvim = inputs.my-neovim.packages.${system}.neovim;
    in
    {
      home.sessionVariables = {
        EDITOR = "${myNvim}/bin/nvim";
      };

      # For some reason hone.sessionVariables doesn't work well
      programs.bash.initExtra = ''
        export EDITOR="${myNvim}/bin/nvim"
      '';

      home.packages = [ myNvim ];
    };
}
