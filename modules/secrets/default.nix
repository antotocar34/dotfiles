{
  config,
  pkgs,
  lib,
  ...
}:
let
  home = config.homedir;
in
{
  homeage = {
    mount = "${home}/.cache/secrets";
    identityPaths = ["${home}/.ssh/antoine"];
    installationType = "activation";
    file."nix-config" = {
      source = ../../homedir/.config/nix/nix-conf.age;
      copies = ["${home}/.config/nix/nix-conf"];
    };
    file."gemini-key" = {
      source = ../../homedir/.secrets/gemini_key.age;
      copies = ["${home}/.secrets/gemini_key"];
    };
  };
}
