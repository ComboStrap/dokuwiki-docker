#!/bin/bash


# ssh_known_hosts_update
#
# This function creates the known hosts file with the github fingerprint.
#
# It is called by the dokuwiki-docker-entrypoint
ssh_known_hosts_update() {

  SSH_KNOWN_HOSTS_FILE="$HOME/.ssh/known_hosts"
  mkdir -p "$(dirname "$SSH_KNOWN_HOSTS_FILE")"
  ## Known Host
  curl --silent https://api.github.com/meta \
    | jq --raw-output '"github.com "+.ssh_keys[]' >> "$SSH_KNOWN_HOSTS_FILE"

  echo_info "Known Hosts file created"

}
