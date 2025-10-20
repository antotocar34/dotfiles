{ lib, ... }:
{
  flake.lib.getSecret =
    config: secret:
    lib.attrsets.attrByPath [
      "age"
      "secrets"
      "${secret}"
      "path"
    ] (lib.warn "The secret '${secret}' was not accessible" "/dev/null") config;
}
