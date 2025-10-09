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
          # forwardAgent = true;
          identityFile = "~/.ssh/website";
        };
        "github" = {
          user = "git";
          port = 22;
          hostname = "github.com";
          host = "github.com";
          # forwardAgent = true;
          identityFile = "~/.ssh/github";
        };
        # "*" = {
        #   identityFile = "~/.ssh/antoine";
        # };
      };
      includes = ["tmp_config"];
    };

  };
}

