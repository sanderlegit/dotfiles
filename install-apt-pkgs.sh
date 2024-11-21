#!/bin/bash

# Update
sudo apt update && sudo apt upgrade

# Git 
sudo apt install -y git
git version

cd /tmp
git clone https://github.com/gitster/git-manpages.git
cd -
sudo make quick-install-man

git config --global user.name "$USER"
git config --global user.email "$USER@dataplumb.in"

# Zsh
sudo apt-get install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
sudo chsh -s $(which zsh) $USER

# Go
## https://go.dev/dl/
wget https://go.dev/dl/go1.23.1.linux-amd64.tar.gz -O /tmp/go.tar.gz
sudo tar -xzvf /tmp/go.tar.gz -C /usr/local
echo export PATH=$HOME/go/bin:/usr/local/go/bin:$PATH >> ~/.zshrc
go version

# Neovim
brew install neovim
# AstroNvim
git clone --depth 1 https://github.com/AstroNvim/template ~/.config/AstroNvim

# Brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
(echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> /home/$USER/.zshrc
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Docker
## Add Docker's official GPG key:
sudo apt-get update
sudo apt-get -y install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo groupadd docker | true
sudo usermod -aG docker $USER
newgrp docker

docker run hello-world

sudo systemctl enable docker.service
sudo systemctl enable containerd.service

# 

# Packages
go install github.com/derailed/k9s@latest

brew install minikube
brew install awscli
brew install helm
brew tap nats-io/nats-tools
brew install nats-io/nats-tools/nats
brew install protobuf
pipx install poetry
brew install pyenv

brew install node
brew install lazygit
brew install fzf
brew install mosh
brew install ripgrep
brew install fd
brew install libpq
brew install bottom
brew install dive
brew link --force libpq




curl https://getcroc.schollz.com | bash

sudo apt -y install nodejs
sudo apt -y install npm
sudo apt -y install pipx
sudo apt -y install zip
pipx ensurepath
python3 -m venv ~/pyenv-default
echo "python3 -m venv ~/pyenv-default" >> ~/.zshconf

source ~/.zshrc

# K8S: 
## Set appropriate File limits
### Increase instances (128 -> 512)
sudo sysctl fs.inotify.max_user_instances=512
### Increase open files (1024 -> 65535)
sudo tee -a /etc/security/limits.conf << EOF
*       soft    nofile  65535
*       hard    nofile  65535
EOF

# 
lscpu
free -h

# Print completion message
echo "Installation complete. You may need to restart your terminal for changes to take effect."
