{ inputs, ... }:
{
  flake.modules.homeManager.cli =
    {
      pkgs,
      system,
      lib,
      ...
    }:
    let
      myNvim = inputs.my-neovim.packages.${system}.nvim;
    in
    {
      home.sessionVariables = {
        EDITOR = "${myNvim}/bin/nvim";
      };

      # For some reason hone.sessionVariables doesn't work well
      programs.bash.initExtra = lib.mkAfter ''
        export EDITOR="$(which nvim)"
        # export EDITOR="${myNvim}/bin/nvim"
      '';

      home.packages =
        let
          # ${myNvim}/bin/nvim -c "lua vim.schedule(function() require('telescope.builtin').find_files() end)"
          nvimGrep = pkgs.writeShellScriptBin "nf" ''
            nvim -c "lua vim.schedule(function() require('telescope.builtin').find_files() end)"
          '';
          nvimFiles = pkgs.writeShellScriptBin "ns" ''
            nvim -c "lua vim.schedule(function() vim.cmd('LiveGrepGitRoot') end)"
          '';
        in
        [
          # myNvim
          nvimGrep
          nvimFiles
        ];
    };
}
