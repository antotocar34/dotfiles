{
  flake.modules.homeManager.base =
    { host, ... }:
    {
      config.xdg.enable = true;
      config.xdg.cacheHome = "${host.homedir}/.cache";
    };
}
