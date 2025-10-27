_default:
  just -f {{justfile_directory()}}/nix.just --list

query_references store_path:
  nix-store --query --requisites {{store_path}}

query_referrers store_path:
  nix-store --query --referrers-closure {{store_path}}

