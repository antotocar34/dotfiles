{ config, lib, ... }:
{
  # config.current_host2 = "foo";
  config.hosts.macbookpro = {
    user = "antoine.carnec";
    hostname = "LONLTMC773WR0";
    isNixos = false;
    isDesktop = true;
    homedir = "/Users/antoine.carnec";
  };
}
