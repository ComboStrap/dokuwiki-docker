#!/bin/bash


ssh_known_hosts_update() {

  KNOWN_HOST=$HOME/.ssh/known_hosts
  if [ -f "$KNOWN_HOST" ]; then
    echo_info "Known Hosts file found (not updated)"
    exit
  fi

  ## Known Host
  curl --silent https://api.github.com/meta \
    | jq --raw-output '"github.com "+.ssh_keys[]' >> ~/.ssh/known_hosts

  echo_info "Known Hosts file created"

}
