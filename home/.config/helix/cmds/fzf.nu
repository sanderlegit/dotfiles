def main [] {
    # sk --ansi --cmd "rg --column --line-number --no-heading --color=always --smart-case --hidden ." --delimiter ":" --preview "bat --color=always {1} --highlight-line {2}" --preview-window "up:60%:border"
  let paths = (do {
    sk --ansi -i -c 'ag --column --color "{}"' --preview $"($env.PREVIEW_SH) {}"
  } | complete).stdout
  
  # Check if no files were selected, and exit if none are
  if ($paths | is-empty) {
    exit 0
  }

  # Parse the selection to get file, line number, and column number
  let parts = ($paths | split row ":")
  let file_path = if ($parts | length) > 0 { $parts.0 } else { $paths }
  let line_num = if ($parts | length) > 1 { $parts.1 } else { "1" }
  let col_num = if ($parts | length) > 2 { $parts.2 } else { "1" }
 
  # Construct the Helix command with file:line:column format
  let file_ref = $file_path + ":" + $line_num + ":" + $col_num
  let run_open = ":open " + $file_ref

  # Execute in Helix via Zellij
  zellij action toggle-floating-panes
  zellij action write 27  # Exit To Normal Mode
  zellij action write-chars $run_open
  zellij action write 13  # Enter
}
