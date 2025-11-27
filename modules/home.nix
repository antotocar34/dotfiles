{ ... }:
{
  flake.modules.homeManager.base =
    {
      config,
      pkgs,
      lib,
      host,
      ...
    }:
    let
      l = lib // builtins;
    in
    {

      options.configPath = l.mkOption {
        type = l.types.str;
      };

      config =
        let
          user = host.user;
          home = host.homedir;
          configPath = "${host.homedir}/.config/dotfiles";
        in
        {

          inherit configPath;
          programs.home-manager.enable = true;


          # TODO: turn this off at some point
          home.enableNixpkgsReleaseCheck = false;

          home.username = user;
          home.homeDirectory = home;
          home.stateVersion = "21.03";

          home.sessionVariables = {
            LOCALE_ARCHIVE = "${home}/.nix-profile/lib/locale/locale-archive";
            NIXPKGS_ALLOW_UNFREE = 1;
            HOME_MANAGER_CONFIG = configPath;
          };

          home.shellAliases = {
            "conf" = "cd ${configPath}";
            "gsee" = "cd $(mktemp -d) && git clone --depth 1 $(pbpaste)";
          };

          home.file =
            let
              inherit (config.lib.file) mkOutOfStoreSymlink;
              link = s: config.lib.file.mkOutOfStoreSymlink "${symlinkRoot}/${s}";
              symlinkRoot = "${configPath}/homedir"; # make sure this is a *string*, not a Nix path

              recursivelyMkOutOfStoreSymlink =
                dirPath:
                let
                  base = builtins.baseNameOf dirPath;
                  rel = p: lib.removePrefix "${toString dirPath}/" (toString p);
                  rels = map rel (lib.filesystem.listFilesRecursive dirPath);
                  keys = map (p: "${base}/${p}") rels;
                in
                lib.genAttrs keys (n: {
                  source = mkOutOfStoreSymlink "${symlinkRoot}/${n}"; # → …/homedir/.config/…
                });
            in
            recursivelyMkOutOfStoreSymlink ../homedir/.config
            // recursivelyMkOutOfStoreSymlink ../homedir/.ssh
            // {
              ".xmodmap".source = link ".xmodmap";
              ".dir_colors".source = link ".dir_colors";
              ".timewarrior/timewarrior.cfg".source = link ".timewarrior/timewarrior.cfg";
              ".ipython".source = link ".ipython";
              ".ipython".recursive = true;
            };

          news.display = "silent";
        };
    };
}
