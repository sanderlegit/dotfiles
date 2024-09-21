#!/bin/bash

sudo apt update && sudo apt upgrade

# Git Config
sudo apt install -y git
git version

cd /tmp
git clone https://github.com/gitster/git-manpages.git
cd -
sudo make quick-install-man

git config --global user.name "$USER"
git config --global user.email "$USER@dataplumb.in"

# Mosh
sudo apt install -y mosh

# Fzf
sudo apt install -y fzf

# croc
curl https://getcroc.schollz.com | bash

# Zsh
sudo apt-get install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
sudo chsh -s $(which zsh) $USER

# Golang
sudo apt-get -y install golang-go 
go version

# https://go.dev/dl/
wget https://go.dev/dl/go1.23.1.linux-amd64.tar.gz -O /tmp/go.tar.gz
sudo tar -xzvf /tmp/go.tar.gz -C /usr/local
echo export PATH=$HOME/go/bin:/usr/local/go/bin:$PATH >> ~/.zshrc
go version

go install github.com/derailed/k9s@latest

# Minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64

# Print completion message
echo "Installation complete. You may need to restart your terminal for changes to take effect."
