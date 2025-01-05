# Dotfiles

# TODO
- Implement Stow
- Add AstroNvim install plus config move `/Users/dries/.config`
  - https://docs.astronvim.com/
- Fix install-apt-pkgs requing `y` and shell escape from zsh

# pkgs to add
```
# istio
 curl -sL https://istio.io/downloadIstioctl | sh -
brew install zsh-completions
```

# zshrc
```
export PATH=$HOME/.istioctl/bin:$PATH

#??? what for
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

  autoload -Uz compinit
  compinit
fi

#??? what for
chmod -R go-w "$(brew --prefix)/share"
```

# system stuff
```
# hostname
sudo hostnamectl set-hostname new-hostname


# passwordless sudo
sudo visudo
# %sudo ALL=(ALL) NOPASSWD: ALL
```
# dotfiles setup
```
git clone git@github.com-unoit6:sanderlegit/dotfiles.git $HOME/.dotfiles


ln -s $HOME/.dotfiles/home/.zshrc $HOME/.zshrc
ln -s $HOME/.dotfiles/home/.tmux $HOME/.tmux
ln -s $HOME/.dotfiles/home/.tmux.conf $HOME/.tmux.conf
ln -s $HOME/.dotfiles/home/.config/k9s $HOME/.config/k9s

```
# gpu
https://docs.nvidia.com/cuda/cuda-installation-guide-linux/

lspci | grep -i nvidia

sudo apt-get update
sudo apt-get install nvidia-cuda-toolkit #formerly cuda-toolkit
sudo apt install libnividia-gl-550
sudo apt install libnvidia-common-550
sudo apt install nvidia-driver-550

# Add NVIDIA repository key
sudo wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-keyring_1.1-1_all.deb
sudo dpkg -i cuda-keyring_1.1-1_all.deb

# Update and install
sudo apt install nvidia-gds

systemctl status nvidia-persistenced
# if bad: sudo systemctl enable nvidia-persistenced

# Zshrc
CUDA_HOME=/usr/local/cuda
PATH=${CUDA_HOME}/bin${PATH:+:${PATH}}
LD_LIBRARY_PATH=${CUDA_HOME}/lib64 ${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
export LD_LIBRARY_PATH
export CUDA_HOME
export PATH

#
sed -i 's/git@github.com:/git@github.com-auguria:/g' .gitmodules
git submodule sync
git submodule update --init --recursive

minikube start --driver=docker --cpus=11 --memory=60001 --disk-size=400g
minikube addons enable metrics-server

# nvidia gpu minikube
https://minikube.sigs.k8s.io/docs/tutorials/nvidia/

brew install nushell
