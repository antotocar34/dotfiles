{...}:
{
  flake.modules.homeManager.cli = {config, info, pkgs, myLib, ...}: {

    imports = [
      (myLib.mkGhModule {
        name="gh-personal"; 
        secretFile = myLib.getSecret config "gh-personal-hosts-yml";
      })
    ];

    programs.git = {
      enable = true;
      aliases = {
        lg = ''log --graph --abbrev-commit --decorate --date=short -10 --format=format:"%C(bold blue)%h%C(reset) %C(bold yellow)%d%C(reset) %C(white)%s%C(reset) %C(green)(%ad)%C(reset) %C(dim white)- %an%C(reset)"'';
        te = ''log --all --graph --decorate=short --color --date=short --format=format:"%C(bold blue)%h%C(reset) %C(bold yellow)%d%C(reset) %C(white)%s%C(reset) %C(green)(%ad)%C(reset) %C(dim white)- %an%C(reset)"'';
        st = "status --short";
        wdiff = "diff --word-diff=color";
        unstage = "reset HEAD --";
        force-push = "push --force-with-lease";
      };
      

      extraConfig = {
        "diff \"nbdiff\"".command = "${pkgs.python313Packages.nbdime}/bin/git-nbdiffdriver diff" ; 
      };

      attributes = [
        "*.ipynb diff=nbdiff"
      ];
      

      userName = info.name;
      userEmail = info.email;
      delta.enable = true;
      delta.options = {
        syntax-theme = "Nord";
        side-by-side = "false";
        paging = "auto";
        line-numbers = "true";
        hunk-header-style = "omit";
        line-numbers-zero-style = "#4C566A";
      };
    };

    programs.gh = {
      enable = true;
      settings.git_protocol = "ssh";
    };
  };

}
