#!/bin/bash

sudo apt update

sudo apt install -y snapd
sudo apt install -y git
sudo apt install -y mosh
sudo apt install -y fzf

sudo apt install -y git
cd /tmp
git clone https://github.com/gitster/git-manpages.git
cd -
sudo make quick-install-man

git config --global user.name "dries"
git config --global user.email "dries@dataplumb.in"

curl https://getcroc.schollz.com | bash

# Print completion message
echo "Installation complete. You may need to restart your terminal for changes to take effect."
