{pkgs, config, ...}: let
  l = pkgs.lib;
  llm-pkg = (pkgs.llm.withPlugins {
          # LLM access to models by Anthropic, including the Claude series <https://github.com/simonw/llm-anthropic>
          llm-anthropic = true;
          # # Use LLM to generate and execute commands in your shell <https://github.com/simonw/llm-cmd>
          llm-cmd = true;
          # LLM plugin to access Google's Gemini family of models <https://github.com/simonw/llm-gemini>
          llm-gemini = true;
        });
in {
  rclone-backup = (
    pkgs.writeShellScriptBin "rclone-backup"
    ''
      ${l.getExe pkgs.rclone} "$@" --filter-from ${../homedir/.config/rclone/exclude_list.txt}
    ''
  );

  lkr = pkgs.writeShellScriptBin "lkr" (builtins.readFile /home/carneca/Documents/projects/locker/lkr);

  ask = pkgs.writeShellApplication {
            name = "ask";
            runtimeInputs = [ llm-pkg ];
            text = builtins.readFile ./ask.sh;
            runtimeEnv = { LLM_GEMINI_KEY_FILE = "${config.age.secrets.gemini-api-key.path}"; };
            excludeShellChecks = ["SC2016"];
          };
}
