#!/bin/bash

# Check if script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# # Prompt for the new username
# read -p "Enter the new username: " NEW_USER
NEW_USER=dries

# Create the new user
useradd -m -s /bin/bash "$NEW_USER"

# Add the user to the sudo group
usermod -aG sudo "$NEW_USER"

# Create .ssh directory for the new user
USER_HOME=$(eval echo ~$NEW_USER)
mkdir -p "$USER_HOME/.ssh"
chmod 700 "$USER_HOME/.ssh"

# Copy root's authorized_keys to the new user
cp /root/.ssh/authorized_keys "$USER_HOME/.ssh/authorized_keys"
chown "$NEW_USER:$NEW_USER" "$USER_HOME/.ssh/authorized_keys"
chmod 600 "$USER_HOME/.ssh/authorized_keys"

# Disable password authentication for the new user
echo "$NEW_USER ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/"$NEW_USER"

# Update SSH configuration to allow password-less login
sed -i 's/^#*PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/^#*ChallengeResponseAuthentication yes/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config
sed -i 's/^#*UsePAM yes/UsePAM no/' /etc/ssh/sshd_config

sudo chown -R $NEW_USER:$NEW_USER /home/$NEW_USER/.ssh
sudo passwd -u dries
sudo passwd dries
sudo usermod -p '*' dries

# Restart SSH service
systemctl restart sshd

echo "User $NEW_USER has been created with sudo privileges and SSH access."
echo "Please test the new user's access before logging out of the root account."
