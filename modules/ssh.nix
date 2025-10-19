{
  flake.modules.homeManager.cli = {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        "website" = {
          user = "git";
          port = 22;
          hostname = "github.com";
          host = "github.com-antoinecarnec";
          identityFile = "~/.ssh/website";
        };
        "github" = {
          user = "git";
          port = 22;
          hostname = "github.com";
          host = "github.com";
          identityFile = "~/.ssh/github";
        };
        "*" = {
          identityFile = "~/.ssh/antoine";
          # identitiesOnly = true;
        };
      };
      includes = ["tmp_config"];
    };

  };
}
