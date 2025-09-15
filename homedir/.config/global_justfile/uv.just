_default:
  just -f {{justfile_directory()}}/uv.just --list

[no-cd]
add_github repo:
  # Example usage uv add git+ssh://github.com/$owner/$repo
  uv add git+ssh://{{repo}}
