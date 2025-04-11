#!/usr/bin/env nu

# This script expects a floating window Zellij pane to be active, it will toggling the floating pane, and write the paths to open in Helix.
#
# Arguments:
#   buffer_paths: string - Paths provided by the caller (e.g., Lazygit file names).
# 
def main [buffer_paths: string] {
    if ($buffer_paths | is-empty) {
        # Exit the script cleanly after attempting explorer action
        exit 0
    } else {
        # Prepare the Helix command
        let run = ":open " + $buffer_paths

        # Send commands to Helix via Zellij
        zellij action toggle-floating-panes # Ensure Helix pane is focused (adjust if needed)
        zellij action write 27              # Send Esc to enter Normal mode
        zellij action write-chars $run      # Type the :open command
        zellij action write 13              # Send Enter to execute
        zellij action toggle-floating-panes # Ensure Helix pane is focused (adjust if needed)
        zellij action write 113             # Send q to exit lazygit
    }
}
