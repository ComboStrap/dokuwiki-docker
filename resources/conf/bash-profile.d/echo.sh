#!/bin/bash

# Get the directory of the current script
SCRIPT_DIR=$(dirname "$0")
source "$SCRIPT_DIR"/color


function cli_name(){
  CLI_NAME="bash"
  if [ "$0" != "-bash" ]; then
    CLI_NAME=$(basename "$0") # Name of the cli
  fi
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
