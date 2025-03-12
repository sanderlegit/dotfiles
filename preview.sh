#!/usr/bin/env bash

REVERSE="\x1b[7m"
RESET="\x1b[m"

if [[ $# -lt 1 ]]; then
  echo "usage: $0 [--tag] FILENAME[:LINENO][:IGNORED]"
  exit 1
fi

if [[ $1 = --tag ]]; then
  shift
  "$(dirname "${BASH_SOURCE[0]}")/tagpreview.sh" "$@"
  exit $?
fi

# Ignore if an empty path is given
[[ -z $1 ]] && exit

# Parse input
IFS=':' read -r -a INPUT <<< "$1"
FILE=${INPUT[0]}
TARGET_LINE=${INPUT[1]}

# Handle Windows-style paths
if [[ "$1" =~ ^[A-Za-z]:\\ ]]; then
  FILE=$FILE:${INPUT[1]}
  TARGET_LINE=${INPUT[2]}
fi

if [[ -n "$TARGET_LINE" && ! "$TARGET_LINE" =~ ^[0-9] ]]; then
  exit 1
fi

TARGET_LINE=${TARGET_LINE/[^0-9]*/}

# MS Win support
if [[ "$FILE" =~ '\' ]]; then
  if [ -z "$MSWINHOME" ]; then
    MSWINHOME="$HOMEDRIVE$HOMEPATH"
  fi
  if grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null ; then
    MSWINHOME="${MSWINHOME//\\/\\\\}"
    FILE="${FILE/#\~\\/$MSWINHOME\\}"
    FILE=$(wslpath -u "$FILE")
  elif [ -n "$MSWINHOME" ]; then
    FILE="${FILE/#\~\\/$MSWINHOME\\}"
  fi
fi

# Expand ~ to home directory
FILE="${FILE/#\~\//$HOME/}"

# Check if file exists and is readable
if [ ! -r "$FILE" ]; then
  if [[ "${INPUT[0]}" != '[No Name]' ]]; then
    echo "File not found ${FILE}"
  fi
  exit 1
fi

# Default to line 0 if no line number provided
if [ -z "$TARGET_LINE" ]; then
  TARGET_LINE=0
fi

# Calculate the start line (20 lines before target, or line 1 if that would be negative)
START_LINE=$((TARGET_LINE > 20 ? TARGET_LINE - 20 : 1))

# Check for bat/batcat
if [[ -z "$BATCAT" ]]; then
  if command -v batcat > /dev/null; then
    BATCAT="batcat"
  elif command -v bat > /dev/null; then
    BATCAT="bat"
  fi
fi

# Use bat if available
if [ -z "$FZF_PREVIEW_COMMAND" ] && [ "${BATCAT:+x}" ]; then
  ${BATCAT} --style="${BAT_STYLE:-numbers}" --theme="ansi" --color=always --pager=never \
      --highlight-line=$TARGET_LINE --line-range=$START_LINE: -- "$FILE"
  exit $?
fi

# Check if file is binary
FILE_LENGTH=${#FILE}
MIME=$(file --dereference --mime -- "$FILE")
if [[ "${MIME:FILE_LENGTH}" =~ binary ]]; then
  echo "$MIME"
  exit 0
fi

# Default command for rendering the file
DEFAULT_COMMAND="highlight -O ansi -l {} || coderay {} || rougify {} || cat {}"
CMD=${FZF_PREVIEW_COMMAND:-$DEFAULT_COMMAND}
CMD=${CMD//{\}/"$(printf %q "$FILE")"}

# Execute the command and process the output
eval "$CMD" 2> /dev/null | awk -v start=$START_LINE -v target=$TARGET_LINE '
  NR >= start {
    if (NR == target) {
      gsub(/\x1b[[0-9;]*m/, "&'$REVERSE'");
      printf("'$REVERSE'%s\n'$RESET'", $0);
    } else {
      printf("'$RESET'%s\n", $0);
    }
  }
'
