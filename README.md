# Dotfiles

# TODO
- Implement Stow
- Add AstroNvim install plus config move `/Users/dries/.config`
  - https://docs.astronvim.com/

brew install ripgrep
brew install fd


brew install libpq
brew link --force libpq

```
 curl -sL https://istio.io/downloadIstioctl | sh -
brew install zsh-completions

# add to zshrc

chmod -R go-w "$(brew --prefix)/share"

```


rc
```
export PATH=$HOME/.istioctl/bin:$PATH
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

  autoload -Uz compinit
  compinit
fi


```
