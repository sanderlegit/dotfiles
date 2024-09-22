#!/bin/bash

# List of organizations and corresponding emails
# Format: "org1:email1@example.com" "org2:email2@example.com"
org_emails=("unit6:sander@unit-6.net" "auguria:sverheijen@auguria.io")

# SSH config file path
ssh_config="$HOME/.ssh/config"

# Function to create and setup an SSH key
create_ssh_key() {
    local org=$1
    local email=$2
    local key_file="$HOME/.ssh/id_ed25519_$org"

    ssh-keygen -t ed25519 -C "$email" -f "$key_file" -q -N ""
    ssh-add "$key_file" > /dev/null 2>&1

    echo "Public key for $org ($email):"
    cat "${key_file}.pub"
    echo
}

# Function to append SSH config
append_ssh_config() {
    local org=$1
    {
        echo
        echo "Host github.com-$org"
        echo "    HostName github.com"
        echo "    User git"
        echo "    IdentityFile ~/.ssh/id_ed25519_$org"
    } >> "$ssh_config"
}

# Start ssh-agent in the background
eval "$(ssh-agent -s)" > /dev/null

# Create keys and update config for each organization
for org_email in "${org_emails[@]}"; do
    IFS=':' read -r org email <<< "$org_email"
    create_ssh_key "$org" "$email"
    append_ssh_config "$org"
done

echo "SSH keys created and config updated for the following organizations:"
for org_email in "${org_emails[@]}"; do
    IFS=':' read -r org email <<< "$org_email"
    echo "- $org ($email)"
done

echo "Add the public keys to your respective GitHub accounts"
echo "Use git@github.com-<org>:<username>/<repo>.git for cloning/remote URLs"
