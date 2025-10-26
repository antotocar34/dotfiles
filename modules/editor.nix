{ inputs, ... }:
{
  flake.modules.homeManager.cli =
    { pkgs, system, ... }:
    let
      myNvim = inputs.my-neovim.packages.${system}.nvim;
    in
    {
      home.sessionVariables = {
        EDITOR = "${myNvim}/bin/nvim";
      };

      # For some reason hone.sessionVariables doesn't work well
      programs.bash.initExtra = ''
        export EDITOR="${myNvim}/bin/nvim"
      '';

      home.packages =
        let
          nvimGrep = pkgs.writeShellScriptBin "nf" ''
            ${myNvim}/bin/nvim -c "lua vim.schedule(function() require('telescope.builtin').find_files() end)"
          '';
          nvimFiles = pkgs.writeShellScriptBin "ns" ''
            ${myNvim}/bin/nvim -c "lua vim.schedule(function() vim.cmd('LiveGrepGitRoot') end)"
          '';
        in
        [
          # myNvim
          nvimGrep
          nvimFiles
        ];
    };
}
