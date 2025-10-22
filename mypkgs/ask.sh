LLM_GEMINI_KEY="$(cat "${LLM_GEMINI_KEY_FILE}")"
export LLM_GEMINI_KEY

MODEL="gemini-flash-latest"
PROMPT=""
SYSTEM_PROMPT="You are a helpful AI assistant accessed via a command line. Your responses must be terse, to the point, and contained within a single paragraph. Use newlines for readability. Do not engage in unnecessary conversation. If the user asks you to give a longer answer, only do so for one response, then resume with your terse responses."
QUICK=false
THINK=false
GOOGLE_OPT=""
CODE_OPT=""
NEW_CONVERSATION=false

# Parse arguments
for arg in "$@"; do
  case $arg in
    -t|--think)
      THINK=true
      shift
      ;;
    -q|--quick)
      QUICK=true
      shift
      ;;
    -g|--google)
      GOOGLE_OPT="-o google_search 1"
      shift
      ;;
    -c|--code)
      CODE_OPT="-o code_execution 1"
      shift
      ;;
    -n|--new-conversation)
      NEW_CONVERSATION=true
      shift
      ;;
    *)
      PROMPT="$PROMPT$arg "
      shift
      ;;
  esac
done

# Set model based on --think flag
if [ "$THINK" = true ]; then
  MODEL="gemini-2.5-pro"
fi
# Set model based on --think flag
if [ "$QUICK" = true ]; then
  MODEL="gemini-2.5-flash-lite"
fi
#
# Set model based on --new-conversation flag
CONTINUE_STRING="--continue"
if [ "$NEW_CONVERSATION" = true ]; then
  CONTINUE_STRING=""
fi

# Assemble the command
COMMAND="llm $CONTINUE_STRING -m \"$MODEL\" --system \"$SYSTEM_PROMPT\" $GOOGLE_OPT $CODE_OPT"

# Execute based on input type (pipe or arguments)
if [ -t 0 ]; then
  if [ -z "$PROMPT" ]; then
    echo "Usage: ask <prompt> [-t|--think] [-g|--google] [-c|--code] [-n|--new-conversation]"
    echo "       <some_command> | ask <prompt>"
    exit 1
  fi
  eval "$COMMAND \"$PROMPT\""
else
  if [ -n "$PROMPT" ]; then
    (cat -; printf "\\n%s" "$PROMPT") | eval "$COMMAND"
  else
    cat - | eval "$COMMAND"
  fi
fi

