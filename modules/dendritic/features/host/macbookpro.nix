{ ... }:
{
  flake.modules.homeManager."host-macbookpro" = { ... }:
    {
      config.host.user = "antoine.carnec";
      config.host.hostname = "LONLTMC773WR0";
      config.host.isNixos = false;
      config.host.isDesktop = true;
      config.homedir = "/Users/antoine.carnec";
    };
}
