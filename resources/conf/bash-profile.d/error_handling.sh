#!/bin/bash


print_stack(){
  # CallStack with FUNCNAME
  # The FUNCNAME variable exists only when a shell function is executing.
  # The last element is `main` with the current script being 0

  # If FUNCNAME has only one element, it's the main script
  # No stack print needed
  if [ ${#FUNCNAME[@]} = 1 ]; then
      return;
  fi
  echo_err "Call Stack:"
  for ((i=0; i < ${#FUNCNAME[@]}; i++)) do
      echo_err "  $i: ${BASH_SOURCE[$i]}#${FUNCNAME[$i]}:${BASH_LINENO[$i]}"
  done
}

# Define the error handling function
error_handler() {

    local err=$?
    local line=$1
    local command="$2"
    echo_err "Error on ${BASH_SOURCE[1]} line $line"
    echo_err ""
    echo_err "Command '$command' exited with status $err."
    echo_err ""
    print_stack

}


## A trap on ERR, if set, is executed before the shell exits.
# Because we show the $LINENO, we need to pass a command to the trap and not a function otherwise the line number would be not correct
trap 'error_handler "$LINENO" "${BASH_COMMAND}"' ERR

## A simple trap to copy on external file
# trap 'echo_err ""; echo_err "Command error on line ($0:$LINENO)"; exit 1' ERR