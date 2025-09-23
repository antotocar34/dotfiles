set_ssh:
  @echo "export SSH_AUTH_SOCK=$(echo "${TMPDIR}rbw-$(id -u)/ssh-agent-socket")"

