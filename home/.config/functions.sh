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

# ---------------------------------------------------------------------------
# USAGE:
#   <file_list_command> | dir-sizes
#   dir-sizes <file1> <file2> ...
#
# DESCRIPTION:
#   Calculates and displays statistics for a list of files, grouping the
#   results in a hierarchical, depth-first manner.
#
#   The output is sorted first by the top-level directory and then by the
#   full directory path, ensuring a logical, nested structure. A grand
#   total of the top-level directories is displayed at the end.
#
# EXAMPLES:
#   git-files-fd timeout | dir-sizes
#   dir-sizes $(fd -e ts -e go)
# ---------------------------------------------------------------------------
dir-sizes() {

  # This subshell handles input: it uses arguments if provided,
  # otherwise it reads from standard input (a pipe).
  (
    if [ "$#" -gt 0 ]; then
      printf "%s\n" "$@"
    else
      cat
    fi
  ) |
    # Take the file list and get line/word counts for all files in one go.
    xargs wc -l -w | sed '$d' |
    # First awk pass: Process the output from `wc`.
    # For each file, generate all its parent prefixes and sum up the stats.
    awk '
  {
      # In the output from `wc`, the filename starts at field 3.
      # This loop correctly reassembles filenames that contain spaces.
      filename = $3;
      for (i=4; i<=NF; i++) {
          filename = filename " " $i;
      }

      # Split the filename by "/" to find all parent directories (prefixes).
      n = split(filename, parts, "/");

      # Loop through the parts to build each prefix and add the file stats.
      prefix = "";
      for (i = 1; i < n; i++) {
          prefix = (prefix == "" ? parts[i] : prefix "/" parts[i]);
          files[prefix]++;
          lines[prefix] += $1; # $1 is line count from wc
          words[prefix] += $2; # $2 is word count from wc
      }
  }
  END {
      # After processing all files, output the aggregated stats.
      # A tab (\t) is used as a separator to robustly handle spaces in paths.
      for (p in files) {
          split(p, toplevel_parts, "/");
          toplevel = toplevel_parts[1];
          # Output format: toplevel_dir<TAB>files<TAB>lines<TAB>words<TAB>full_prefix
          printf "%s\t%d\t%d\t%d\t%s\n", toplevel, files[p], lines[p], words[p], p;
      }
  }' |
    # Sort the data.
    # -k1,1: Primary sort groups by the top-level directory.
    # -k5,5: Secondary sort by the full prefix path, creating a natural hierarchy.
    sort -t$'\t' -k1,1 -k5,5 |
    # Final awk pass: Format the sorted data into a clean, dynamic table.
    awk -F'\t' '
  {
      # Read all sorted input into memory, storing each field in an array.
      toplevel[NR] = $1;
      files[NR] = $2;
      lines[NR] = $3;
      words[NR] = $4;
      prefix[NR] = $5;

      # Keep track of the longest prefix path we have seen so far.
      if (length($5) > max_width) {
          max_width = length($5);
      }
  }
  END {
      # Set a minimum width to ensure the "PREFIX" header always fits.
      if (max_width < 11) { max_width = 11; } # Adjusted for "TOTAL      "
      
      # Dynamically create the format string and separator line based on the max width.
      header_format = "%-" max_width "s %10s %10s %10s\n";
      data_format = "%-" max_width "s %10d %10d %10d\n";
      separator = "";
      for (i=1; i<=max_width; i++) { separator = separator "-"; }

      # Print the header.
      printf(header_format, "PREFIX", "FILES", "LINES", "WORDS");
      printf(header_format, separator, "----------", "----------", "----------");

      # Initialize grand total counters.
      grand_total_files = 0;
      grand_total_lines = 0;
      grand_total_words = 0;

      # Loop through the stored data and print the final formatted table.
      for (i=1; i<=NR; i++) {
          # If the top-level directory changes, print a blank line for grouping.
          if (last_toplevel != "" && last_toplevel != toplevel[i]) {
              print "";
          }
          
          # Print the formatted data line.
          printf(data_format, prefix[i], files[i], lines[i], words[i]);
          
          # If it is a top-level directory (no "/"), add to grand totals.
          if (index(prefix[i], "/") == 0) {
              grand_total_files += files[i];
              grand_total_lines += lines[i];
              grand_total_words += words[i];
          }

          # Update the group tracker for the next iteration.
          last_toplevel = toplevel[i];
      }
      
      # Print a blank line and separator before the grand total.
      print "";
      printf(header_format, separator, "----------", "----------", "----------");
      # Print the grand total line.
      printf(data_format, "TOTAL      ", grand_total_files, grand_total_lines, grand_total_words);
  }'
}

case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) export PATH=$PATH:$HOME/.local/bin ;;
esac

aug-env

export PATH="/opt/homebrew/opt/libiconv/bin:$PATH"
export LDFLAGS="$LDFLAGS -L/opt/homebrew/opt/libiconv/lib"
export CPPFLAGS="$CPPFLAGS -I/opt/homebrew/opt/libiconv/include"

yt2txt() {
  local lang=en width="${YT2TXT_WIDTH:-100}"
  while [ $# -gt 0 ]; do
    case "$1" in
      -l|--lang)  lang="$2";  shift 2 ;;
      -w|--width) width="$2"; shift 2 ;;
      --) shift; break ;;
      -*) echo "yt2txt: unknown option $1" >&2; return 1 ;;
      *) break ;;
    esac
  done
  if [ $# -eq 0 ]; then
    echo "usage: yt2txt [-l lang] [-w width] <url-or-id> [more urls...]" >&2
    return 1
  fi

  local first=1 input id title
  for input in "$@"; do
    case "$input" in
      *youtube.com*|*youtu.be*)
        id=$(printf '%s' "$input" | sed -nE \
          -e 's/.*[?&]v=([A-Za-z0-9_-]{11}).*/\1/p' \
          -e 's#.*youtu\.be/([A-Za-z0-9_-]{11}).*#\1#p' \
          -e 's#.*/shorts/([A-Za-z0-9_-]{11}).*#\1#p' | head -n1) ;;
      *) id="$input" ;;
    esac
    if [ -z "$id" ]; then
      echo "yt2txt: couldn't parse a video id from: $input" >&2
      continue
    fi

    [ $first -eq 0 ] && printf '\n\n'
    first=0

    title=$(curl -s "https://www.youtube.com/oembed?format=json&url=https://www.youtube.com/watch?v=$id" \
      | python3 -c 'import sys,json;print(json.load(sys.stdin).get("title",""))' 2>/dev/null)
    [ -z "$title" ] && title="$id"

    printf '===== %s =====\n\n' "$title"
    youtube_transcript_api "$id" --languages "$lang" --format text | fmt -w "$width"
  done
}
