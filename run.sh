#!/bin/bash


################################################################################
# Info
################################################################################

# TODO What is this script for?
# TODO How to use this script?


################################################################################
# Generic
################################################################################

# Bash safe mode.
# From: http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'
# Disable -e temporarily if sub-scripts caouse problems, or returning non-zero is
# intended behaviour.
# Disable -u temporarily when sourcing a script that causes problems

# echo for stderr
function errcho()
{
  set +e; # Avoid recursively reporting errors of errcho() itself
  >&2 echo "${@}";
  set -e;
  return 0;
}

# Catch-all error handling that displays abnoxious warning to screen
# when something bad happens (requires set -e).
function report_error()
{
  if [ "$1" != "0" ]; then
    # error handling goes here
    errcho "[ERROR] $0 {$(pwd)}: Exit status [$1] occurred on line ($2)";
  fi
}
trap 'report_error $? $LINENO' EXIT;

# Move to parent directory for behaviour independent of script location
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_path"
echo "[LOG] Beginning of script [$0] <-- [$@] @ [$parent_path]";


################################################################################
# TODO Add commands here
################################################################################

command_names=("default");
declare -A commands;
function add_command()
{
  command_names+=("$1");
  return 0;
}

# Default command (when no arguments are given)
function command_default()
{
  #set -vx;

  # versioned
  #python3.9 chessgraph.py  --depth=8 --alpha=30 --beta=50 --concurrency 2 --source engine --engine stockfish_23041007_x64_modern --enginedepth 12 --boardstyle svg --position="r1bqkbnr/pppp1ppp/2n5/1B2p3/4P3/5N2/PPPP1PPP/RNBQK2R b KQkq - 0 1"
  # vanilla
  python3.9 chessgraph.py  --depth=8 --alpha=30 --beta=50 --concurrency 4 --source engine --engine stockfish --enginedepth 16 --boardstyle svg --position="r1bqkbnr/pppp1ppp/2n5/1B2p3/4P3/5N2/PPPP1PPP/RNBQK2R b KQkq - 0 1"

  #set +vx;

  return "$?";
}

# Print list available commands (rudimentary help)
add_command print_commands;
function command_print_commands()
{
  echo "$0 commands: ${commands[@]}";
  return 0;
}


################################################################################
# Command dispatcher
################################################################################

# Create command dictionary
for com in "${command_names[@]}"; do
  commands["$com"]="command_${com}";
done

# Call command from args
if [ $# -ge 1 ]; then
  ${commands["$1"]} "${@:2}"; # Pass rest of the arguments to subcommand
else
  ${commands[default]};
fi

exit "$?";


################################################################################
# Example Code
################################################################################

# Traps
  # https://medium.com/@dirk.avery/the-bash-trap-trap-ce6083f36700
  # We can trap:
  #  err, exit, sig{int|term}, kill
  # When the specified event occurs, the trap code is executed.
  # Afterwards the script continues as usual.
  # Functions have a trap sope separate from the global scope!
  #
  # Use with set -e o "throw" on error
  trap 'report_error $? $LINENO' EXIT

# Compare strings
  if [[ "s1" == "ss2" ]]; # Not all shells but cooler
  if [ "s1" = "s2" ];

# File system
  # Test file existance
  if [ -f /tmp/file.txt ];
  # Test dir existance
  if [ -d /tmp/dir ];

# Builtin types
  # Arrays
    # Create array
    array_name=("1" "2" "3" "4"); # Array with 4 elements
    # Get arguments as array
    all_args="${@}";
    last_args="${@:3}"; # Only from 3rd arg onwards
    # Get array length
    if [ "${#array_name[@]}" -eq 4 ]; # true
  # Dictionaries
    # Create Dictionary
    declare -A dictionary_name
    # Access and add elements
    dictionary_name[key] = value
    # Iterate and get
    echo ${dictionary_name[@]} #### get all values
    echo ${dictionary_name[*]}  ### get all values
    echo ${!dictionary_name[*]}  ### get all keys
  # Functions
    # Create function
    function function_name()
    {
      echo "$1"; # Output first function argument
    }
    # Pass Arguments
    function_name "arg1" "arg2";

# Linux utils cheat sheet
  # tar
    # -v verbose
    # -x extract
    # -c create
    # -j bzip2
    # -f <input_file>
    # -S special treatment for sparse files
    #.tar.bz2
      tar [-C /path/dir/] -xjf file.tar.bz2
      tar -cvjSf new_tarball.tar.bz2 ./src/
