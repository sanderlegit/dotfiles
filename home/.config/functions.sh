#!/bin/bash

#!/bin/bash

# SYNOPSIS
#   git-files [FILTER_NAME...]
#
# DESCRIPTION
#   Lists files tracked by Git, applying one or more custom filters.
#   The function looks for files named ".filter=FILTER_NAME" for each argument.
#
#   ORDER OF OPERATIONS:
#   1. All patterns from #include filters are combined. If any exist, the initial
#      file list is filtered to ONLY include files matching these patterns.
#      If no #include filters are provided, the initial list contains all tracked files.
#   2. The resulting list is then filtered to REMOVE any files matching patterns
#      from any #exclude filters.
#
#   This allows for powerful combinations, e.g., "show me all 'rust' files,
#   but exclude any in the 'tests' or 'target' directory".
#
# EXAMPLES
#   # Given .filter=rust:
#   #include
#   \.rs$
#   Cargo.toml
#
#   # Given .filter=no-tests:
#   #exclude
#   /tests/
#
#   # Command:
#   git-files rust no-tests
#
#   # Result:
#   Equivalent to: git ls-files | grep -e '\.rs$' -e 'Cargo.toml' | grep -v -e '/tests/'
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

    local mode
    mode=$(head -n 1 "$filter_file")

    # Read patterns from the current file into a temporary array
    local current_patterns=()
    while IFS= read -r line; do
        # Skip empty lines or comment lines
        if [[ -n "$line" && ! "$line" =~ ^\s*# ]]; then
            current_patterns+=("$line")
        fi
    done < <(tail -n +2 "$filter_file")

    # Add the collected patterns to the appropriate master list
    case "$mode" in
      '#include')
        include_patterns+=("${current_patterns[@]}")
        ;;
      '#exclude')
        exclude_patterns+=("${current_patterns[@]}")
        ;;
      *)
        echo "Warning: Invalid mode '${mode}' in '${filter_file}'. Skipping." >&2
        ;;
    esac
  done

  # 3. --- Build grep arguments from the collected patterns ---
  local include_grep_args=()
  for pattern in "${include_patterns[@]}"; do
    include_grep_args+=(-e "$pattern")
  done

  local exclude_grep_args=()
  for pattern in "${exclude_patterns[@]}"; do
    exclude_grep_args+=(-e "$pattern")
  done

  # 4. --- Construct and execute the command pipeline ---

  # This function gets the initial list of files.
  # It applies the #include filters if they exist.
  local function get_initial_list() {
    if (( ${#include_grep_args[@]} > 0 )); then
      git ls-files | grep "${include_grep_args[@]}"
    else
      # If no includes, start with all files
      git ls-files
    fi
  }

  # This function applies the #exclude filters to its standard input.
  local function apply_exclusions() {
    if (( ${#exclude_grep_args[@]} > 0 )); then
      # The -v flag inverts the match for all -e patterns
      grep -v "${exclude_grep_args[@]}"
    else
      # If no excludes, just pass the input through
      cat
    fi
  }

  # Execute the final pipeline
  get_initial_list | apply_exclusions
}


