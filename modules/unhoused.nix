{
  flake.modules.homeManager.base = {host, config, ...}@args: {
    config.xdg.enable = true;
    config.xdg.cacheHome = "${host.homedir}/.cache";
  };
}
