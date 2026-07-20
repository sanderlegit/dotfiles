#!/bin/bash
# Save as ~/.config/zellij/scripts/fzf-file-search.sh

# Do the file selection
rg --files | fzf --preview "bat --color=always {}" --preview-window "right,60%" > /tmp/zellij_selected

# Only proceed if we got a selection
if [ -s /tmp/zellij_selected ]; then
    zellij action close-pane
    sleep 0.1  # Give the pane time to close
    zellij action write-chars ":open $(cat /tmp/zellij_selected)"
    rm /tmp/zellij_selected
    zellij action write 13
fi
