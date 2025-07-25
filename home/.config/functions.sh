#!/bin/bash

# SYNOPSIS
#   git-files [FILTER_NAME...]
#
# DESCRIPTION
#   Lists files tracked by Git, applying one or more custom filters.
#   The function looks for files named ".ai/filter=FILTER_NAME" for each argument.
#
#   ORDER OF OPERATIONS:
#   1. A base list of all tracked files is retrieved using `git ls-files`.
#   2. The list is filtered by all '#include' patterns using `grep -e`. If no
#      include patterns are provided, this step is skipped.
#   3. The resulting list is then filtered to REMOVE any files matching patterns
#      from any '#exclude' sections using `grep -v -e`.
#
git-files() {
  # 1. --- Input Validation ---
  if [[ $# -eq 0 ]]; then
    echo "Usage: git-files [FILTER_NAME...]" >&2
    echo "Error: You must provide the name of at least one filter." >&2
    return 1
  fi

  # 2. --- Collect all patterns from all filter files ---
  local include_patterns=()
  local exclude_patterns=()

  for filter_name in "$@"; do
    local filter_file=".ai/filter=${filter_name}"

    if [[ ! -f "$filter_file" ]]; then
      echo "Warning: Filter file '${filter_file}' not found. Skipping." >&2
      continue
    fi

    local mode="" # Can be 'include', 'exclude', or empty

    while IFS= read -r line; do
      line=$(echo "$line" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

      if [[ "$line" == "#include" ]]; then
        mode="include"
        continue
      fi
      if [[ "$line" == "#exclude" ]]; then
        mode="exclude"
        continue
      fi
      if [[ -z "$line" || "$line" =~ ^\s*# ]]; then continue; fi

      case "$mode" in
      'include') include_patterns+=("$line") ;;
      'exclude') exclude_patterns+=("$line") ;;
      *)
        echo "Warning: Pattern '${line}' in '${filter_file}' appears before any #include or #exclude directive. Skipping." >&2
        ;;
      esac
    done <"$filter_file"
  done

  # 3. --- Construct and execute the command pipeline ---
  local command_pipeline="git ls-files"

  # Build the include command part, quoting each pattern for shell safety
  if ((${#include_patterns[@]} > 0)); then
    local include_cmd_part=" | grep"
    for pattern in "${include_patterns[@]}"; do
      include_cmd_part+=$(printf " -e %q" "$pattern")
    done
    command_pipeline+="$include_cmd_part"
  fi

  # Build the exclude command part, quoting each pattern
  if ((${#exclude_patterns[@]} > 0)); then
    local exclude_cmd_part=" | grep -v"
    for pattern in "${exclude_patterns[@]}"; do
      exclude_cmd_part+=$(printf " -e %q" "$pattern")
    done
    command_pipeline+="$exclude_cmd_part"
  fi

  # Execute the final, safely-quoted pipeline
  eval "$command_pipeline"
}

# SYNOPSIS
#   git-files-fd [FILTER_NAME...]
#
# DESCRIPTION
#   Lists files in the current directory, applying custom filters using 'fd' and 'grep'.
#   The function looks for files named ".ai/filter=FILTER_NAME" for each argument.
#
#   ORDER OF OPERATIONS:
#   1. A base list of all files is retrieved using `fd`.
#   2. The list is filtered by all '#include' patterns using `grep -e`.
#   3. The resulting list is filtered again to REMOVE matches from '#exclude' patterns.
#
git-files-fd() {
  # 1. --- Input Validation ---
  if [[ $# -eq 0 ]]; then
    echo "Usage: git-files-fd [FILTER_NAME...]" >&2
    echo "Error: You must provide the name of at least one filter." >&2
    return 1
  fi

  if ! command -v fd &>/dev/null; then
    echo "Error: 'fd' command not found. Please install it to use this script." >&2
    return 1
  fi

  # 2. --- Collect all patterns from all filter files ---
  local include_patterns=()
  local exclude_patterns=()

  for filter_name in "$@"; do
    local filter_file=".ai/filter=${filter_name}"

    if [[ ! -f "$filter_file" ]]; then
      echo "Warning: Filter file '${filter_file}' not found. Skipping." >&2
      continue
    fi

    local mode="" # Can be 'include', 'exclude', or empty

    while IFS= read -r line; do
      line=$(echo "$line" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

      if [[ "$line" == "#include" ]]; then
        mode="include"
        continue
      fi
      if [[ "$line" == "#exclude" ]]; then
        mode="exclude"
        continue
      fi
      if [[ -z "$line" || "$line" =~ ^\s*# ]]; then continue; fi

      case "$mode" in
      'include') include_patterns+=("$line") ;;
      'exclude') exclude_patterns+=("$line") ;;
      *)
        echo "Warning: Pattern '${line}' in '${filter_file}' appears before any #include or #exclude directive. Skipping." >&2
        ;;
      esac
    done <"$filter_file"
  done

  # 3. --- Construct and execute the command pipeline ---
  # Start with fd to get all files, including hidden ones.
  local command_pipeline="fd --hidden --type f ."

  # Build the include command part, quoting each pattern for shell safety
  if ((${#include_patterns[@]} > 0)); then
    local include_cmd_part=" | grep"
    for pattern in "${include_patterns[@]}"; do
      include_cmd_part+=$(printf " -e %q" "$pattern")
    done
    command_pipeline+="$include_cmd_part"
  fi

  # Build the exclude command part, quoting each pattern
  if ((${#exclude_patterns[@]} > 0)); then
    local exclude_cmd_part=" | grep -v"
    for pattern in "${exclude_patterns[@]}"; do
      exclude_cmd_part+=$(printf " -e %q" "$pattern")
    done
    command_pipeline+="$exclude_cmd_part"
  fi

  # Execute the final, safely-quoted pipeline
  eval "$command_pipeline"
}
