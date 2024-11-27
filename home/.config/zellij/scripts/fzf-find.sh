#!/bin/bash
# Save as ~/.config/zellij/scripts/fzf-find.sh

# Run fzf with rg and store the result
selected=$(rg --column --line-number --no-heading --color=always --smart-case "" | \
    fzf --ansi --disabled \
        --bind "start:reload:$RG_PREFIX {q}" \
        --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
        --delimiter : \
        --preview "bat --color=always {1} --highlight-line {2}" \
        --preview-window "up,60%,border-bottom,+{2}+3/3,~3" \
        --bind "enter:become(echo {1})")

# If a file was selected, write it to a temporary file
if [ -n "$selected" ]; then
    echo "$selected" > /tmp/zellij_file_selection
fi
