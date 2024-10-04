#!/bin/bash

# Get the directory of the current script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source "$SCRIPT_DIR"/color.sh


function cli_name(){
  # caller return the line, the function and the script
  # example: 10 main /opt/dokuwiki-docker/bin/dokuwiki-docker-entrypoint
  CALLING_SCRIPT=$(caller 1 | awk '{print $3}')
  # Name of the calling script
  CLI_NAME=$(basename "$CALLING_SCRIPT")
  echo "$CLI_NAME"
}


# Echo an info message
function echo_info() {

  echo -e "$(cli_name): ${1:-}"

}

# Print the error message $1
echo_err() {
  echo_info "${RED}Error: $1${NC}"
}

# Function to echo text in green (for success messages)
echo_success() {
    echo_info -e "${GREEN}Success: $1${NC}"
}

# Function to echo text in yellow (for warnings)
echo_warning() {
    echo_info -e "${YELLOW}Warning: $1${NC}"
}

export -f echo_info
export -f echo_err