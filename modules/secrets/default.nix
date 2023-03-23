{
  config,
  pkgs,
  lib,
  ...
}:
let
  home = "/home/${config.host.user}";
in
{
  homeage = {
    identityPaths = ["${home}/.ssh/antoine"];
    installationType = "activation";

    file."rclone_config" = {
      source = ../../homedir/.config/rclone/rclone.conf.age;
      copies = ["${home}/.config/rclone/rclone.conf"];
    };
    file."msmtp_config" = {
      source = ../../homedir/.config/msmtp/config.age;
      copies = ["${home}/.config/msmtp/config"];
    };
    file."weekly_dl_config" = {
      source = ../../homedir/.config/weekly_dl/config.json.age;
      copies = ["${home}/.config/weekly_dl/config.json"];
    };
  };
}
