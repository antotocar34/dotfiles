{
  flake.modules.homeManager.base = {host, ...}@args: {
    config.xdg.enable = true;
    config.xdg.cacheHome = "${host.homedir}/.cache";
  };
}
