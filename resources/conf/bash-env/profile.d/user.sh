#!/bin/bash


# This script is called by `/etc/profile`
# Run on non-interactive, ie when the terminal starts

# Note we can also fake it with https://cwrap.org/nss_wrapper.html
# See example: https://github.com/docker-library/postgres/pull/448/files

USER_UID=$(id -u)
USER_NAME=$(whoami 2> /dev/null || echo 'noname')
echo_info "User: $USER_NAME, UID: $USER_UID, GID: $(id -g)"
if [ "$HOME" == '/' ] && [ "$USER_UID" != '0' ]; then
  # to avoid error with the HOME directory
  # such as `error: could not lock config file //.gitconfig: Permission denied`
  # Issue: https://gitlab.com/gitlab-org/gitlab-runner/-/issues/37408
  export HOME=/home/$USER_NAME
  echo "HOME: $HOME"
  if [ ! -d "$HOME" ]; then
      echo_info "Creating HOME=$HOME"
      mkdir -p "$HOME"
  fi
fi


