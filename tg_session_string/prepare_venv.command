#!/usr/bin/env bash

# Pure bash dirname implementation
getdir() {
  case "$1" in
    */*)
      dir="${1%/*}"
      if [ -z "$dir" ]; then
        echo "/"
      else
        echo "$dir"
      fi
    ;;
    *) echo "." ;;
  esac
}

# Switch to the location of the script file
cd "$(getdir "${BASH_SOURCE:-$0}")" > /dev/null 2>&1

FILE=$(basename "$0")
FILE="./${FILE%.*}.sh"

exec $FILE
