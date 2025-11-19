{
  flake.modules.homeManager.cli =
  {
    config,
    pkgs,
    lib,
    ...
  }:
  let
    inherit (lib) mkOption types;
    cfg = config.programs.rbwProfile;
    
    # Helper for Darwin check
    inherit (pkgs.stdenv.hostPlatform) isDarwin;

    jsonFormat = pkgs.formats.json { };

    # --- Option Definitions ---

    settingsModule = types.submodule {
      freeformType = jsonFormat.type;
      options = {
        email = mkOption {
          type = types.str;
          example = "name@example.com";
          description = "The email address for your bitwarden account.";
        };
        base_url = mkOption {
          type = with types; nullOr str;
          default = null;
          description = "The base-url for a self-hosted bitwarden installation.";
        };
        identity_url = mkOption {
          type = with types; nullOr str;
          default = null;
          description = "The identity url for your bitwarden installation.";
        };
        lock_timeout = mkOption {
          type = types.ints.unsigned;
          default = 3600;
          description = "The amount of time that your login information should be cached.";
        };
        pinentry = mkOption {
          type = types.nullOr types.package;
          default = null;
          description = "Which pinentry interface to use.";
          # Transform package to string path for the JSON config
          apply = val: if val == null then val else lib.getExe val;
        };
      };
    };

    rbwDefinitionModule = {
      options = {
        package = lib.mkPackageOption pkgs "rbw" {
          extraDescription = "Package providing the rbw tool.";
        };

        settings = mkOption {
          type = types.nullOr settingsModule;
          default = null;
          description = "rbw configuration. If null, config is not managed.";
        };
      };
    };

  in
  {
    options = {
      programs.rbwProfile = mkOption {
        default = { };
        type = types.lazyAttrsOf (types.submodule rbwDefinitionModule);
        description = "Define multiple rbw profiles.";
      };
    };

    config = lib.mkIf (cfg != { }) {
      
      # 1. Generate Packages (rbw + wrapper) for all profiles
      home.packages = lib.concatLists (lib.mapAttrsToList (name: profile: 
        let
          rbwWrapper = pkgs.writeShellScriptBin "rbw-${name}" ''
            RBW_PROFILE="${name}" ${profile.package}/bin/rbw "$@"
          '';
        in
        [
          profile.package
          rbwWrapper
        ]
      ) cfg);

      # 2. Generate Config Files for Linux (XDG)
      xdg.configFile = lib.mkIf (!isDarwin) (
        lib.mapAttrs' (name: profile: 
          lib.nameValuePair "rbw-${name}/config.json" (
            # Only generate the source if settings exist
            lib.mkIf (profile.settings != null) {
              source = jsonFormat.generate "rbw-config-${name}.json" profile.settings;
            }
          )
        ) cfg
      );

      # 3. Generate Config Files for macOS
      home.file = lib.mkIf isDarwin (
        lib.mapAttrs' (name: profile: 
          lib.nameValuePair "Library/Application Support/rbw-${name}/config.json" (
            lib.mkIf (profile.settings != null) {
              source = jsonFormat.generate "rbw-config-${name}.json" profile.settings;
            }
          )
        ) cfg
      );
    };
  };
}
