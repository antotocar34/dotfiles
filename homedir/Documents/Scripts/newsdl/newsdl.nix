{pkgs}: 
pkgs.writeShellApplication {
  name = "newsdl";
  text = builtins.readFile ./newsdl.bash;
  runtimeInputs = with pkgs; [mutt calibre];
}

