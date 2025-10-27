_default:
  just -f {{justfile_directory()}}/nix.just --list

query_references store_path:
  nix-store --query --requisites {{store_path}}

query_referrers store_path:
  nix-store --query --referrers-closure {{store_path}}

restart_daemon_mac:
  sudo launchctl kickstart -k system/systems.determinate.nix-daemon

