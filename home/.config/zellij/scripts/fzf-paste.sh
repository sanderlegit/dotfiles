selected=$(cat /tmp/zellij_selected)
rm -f /tmp/zellij_selected
zellij action write-chars ":open $selected"
zellij action write-chars $'\n'
