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
  secretsAvailable = (l.attrByPath ["age"] false config) != false;
  specialOptionalString = cond: string: if cond then string else "/dev/null";
  geminiApiKey = l.attrByPath ["age" "secrets" "gemini-api-key" "path"] "" config;
in {
  rclone-backup = (
    pkgs.writeShellScriptBin "rclone-backup"
    ''
      ${l.getExe pkgs.rclone} "$@" --filter-from ${../homedir/.config/rclone/exclude_list.txt}
    ''
  );

  ask = pkgs.writeShellApplication {
            name = "ask";
            runtimeInputs = [ llm-pkg ];
            text = builtins.readFile ./ask.sh;
            runtimeEnv = { LLM_GEMINI_KEY_FILE = (specialOptionalString secretsAvailable "${geminiApiKey}"); };
            excludeShellChecks = ["SC2016"];
          };
}
