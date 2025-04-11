# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH


eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

export PATH=/home/dries/go/bin:/usr/local/go/bin:/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:/opt/homebrew/Caskroom/miniforge/base/bin:/home/dries/go/bin/:/opt/homebrew/Cellar/csvkit/1.0.7/bin/:/opt/homebrew/Cellar/bash-language-server/2.0.0/:/home/dries/.cargo/bin:/bin:/opt/homebrew/opt/protobuf@3/bin:/home/dries/bin:/usr/local/bin:/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:/opt/homebrew/Caskroom/miniforge/base/bin:/home/dries/go/bin/:/opt/homebrew/Cellar/csvkit/1.0.7/bin/:/opt/homebrew/Cellar/bash-language-server/2.0.0/:/home/dries/.cargo/bin:/bin:/opt/homebrew/opt/protobuf@3/bin:/home/dries/bin:/usr/local/bin:/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:/opt/homebrew/Caskroom/miniforge/base/bin:/home/dries/go/bin/:/opt/homebrew/Cellar/csvkit/1.0.7/bin/:/opt/homebrew/Cellar/bash-language-server/2.0.0/:/home/dries/.cargo/bin:/bin:/opt/homebrew/opt/protobuf@3/bin:/home/dries/bin:/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/opt/homebrew/bin:/Users/dries/Library/Python/3.8/bin:/opt/homebrew/bin:/Users/dries/Library/Python/3.8/bin:/opt/homebrew/bin:/Users/dries/Library/Python/3.8/bin:/usr/local/go/bin:/home/dries/go/bin

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

. "$HOME/.cargo/env"            # For sh/bash/zsh/ash/dash/pdksh

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    git 
    docker-compose
    vi-mode
    colored-man-pages
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"

## WAL

# # alias ohmyzsh="mate ~/.oh-my-zsh"
# # Import colorscheme from 'wal' asynchronously
# # &   # Run the process in the background.
# # ( ) # Hide shell job control messages.
# # Not supported in the "fish" shell.
# (cat ~/.cache/wal/sequences &)

### Terminal Extensions

# Fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

### Terminal Fixes

### QOL Shortcuts

alias llt="ls -lat"

alias clean="mv ~/Desktop/* ~/not_desktop"
rmds () {
	rm $(find . | grep '\.DS_Store')
}

# alias air='~/.air'

alias nosleep="sudo pmset -b disablesleep 1"
alias yessleep="sudo pmset -b disablesleep 0"

alias tp="touch package.json"

alias cu="cd .. && ll"
ci () {
	cd $1 && ll
}

catmd () {
  pandoc $1 | lynx -stdin
}

dkill () {
	docker kill $(docker container ls -q)
}

based () {
	echo $@ | base64 -d
}

rdme () {
	echo "- \`${@}\`" | pbcopy
}

# https://stackoverflow.com/questions/21511337/auto-refresh-browser-on-file-change
watchfile () {
	watchme $1 -e " osascript $HOME/refresh.applescript"
}

procstat () {
    PIDS=""
    for var in "$@"
    do
        PIDS=$PIDS pgrep -l $1 | awk '{split($0,a," "); print a[1]}'
    done    
echo  ps -vmp $PIDS
    ps -vmp $PIDS
}

### Autocompletion/PATH
# Rust
# libpq, for certh postgres
export RUSTFLAGS="-L/opt/homebrew/opt/libpq/lib"
# source $HOME/.cargo/env

# GCP
# PATH for the Google Cloud SDK.
if [ -f '/Users/dries/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/dries/google-cloud-sdk/path.zsh.inc'; fi
# shell command completion for gcloud.
if [ -f '/Users/dries/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/dries/google-cloud-sdk/completion.zsh.inc'; fi

# Terraform
autoload -Uz +X compinit && compinit
autoload -Uz +X bashcompinit && bashcompinit

complete -o nospace -C /opt/homebrew/bin/terraform terraform

# AZ CLI 
# HOMEBREW_PREFIX="$(brew --prefix)"
HOMEBREW_PREFIX="/opt/homebrew"
# source "$HOMEBREW_PREFIX/etc/bash_completion.d/az"

#Protoc
export PATH="/opt/homebrew/opt/protobuf@3/bin:$PATH"

# Brew
export PATH=$PATH:/opt/homebrew/bin
export PATH=$PATH:/Users/dries/Library/Python/3.8/bin

# Created by `pipx` on 2022-03-29 14:02:23
# export PATH="/Users/dries/.local/bin:$PATH"
# export PATH="/opt/homebrew/opt/python@3.9/libexec/bin:$PATH"
export PATH="$CONDA_PREFIX/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="/opt/homebrew/Cellar/bash-language-server/2.0.0/:$PATH"
export PATH="/opt/homebrew/Cellar/csvkit/1.0.7/bin/:$PATH"

# Add Go bin to PATH
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

export PATH=~/.npm-global/bin:$PATH

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/miniforge/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/miniforge/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
#

# Hide desktop
alias hidedesktop="sh ~/bin/hideDesktop.sh"
alias unhidedesktop="sh ~/bin/unhideDesktop.sh"
alias rmspaces="#!/bin/bash

# loop through all files in current directory
for file in *; do
  # Check if the filename contains space
  if [[ "$file" =~ " " ]]; then
    # Replace spaces with no space
    new_file="${file// /}"
    # Rename the file
    mv -- "$file" "$new_file"
  fi
done"

# New vi
# VI mode and prompt configuration
function prompt_status() {
    # Define colors using %F for foreground
    local user_host='%F{green}%n@%m%f'
    local current_dir='%F{cyan}%~%f'
    local git_branch='$(git_prompt_info)'
    local timestamp='%F{yellow}[%D{%H:%M:%S}]%f'
    # Only include space after vi_mode if it's not empty
    local vi_mode='${${KEYMAP/vicmd/"%F{red}N%f "}/(main|viins)/"%F{blue}I%f "}'
    local prompt_char='%F{magenta}➜%f'

    # Git prompt settings
    ZSH_THEME_GIT_PROMPT_PREFIX=" %F{blue}git:(%f%F{red}"
    ZSH_THEME_GIT_PROMPT_SUFFIX="%f"
    ZSH_THEME_GIT_PROMPT_DIRTY="%F{blue}) %F{yellow}✗%f"
    ZSH_THEME_GIT_PROMPT_CLEAN="%F{blue})%f"

    # Set the prompt with newline before prompt character
    PROMPT="${timestamp} ${user_host} ${current_dir}${git_branch} ${vi_mode}
${prompt_char} "
}

# Initialize the prompt
prompt_status

# Set up vi-mode indicators
function zle-line-init zle-keymap-select {
    prompt_status
    zle reset-prompt
}

# Register the widgets
zle -N zle-line-init
zle -N zle-keymap-select

# Vi mode settings
bindkey 'jk' vi-cmd-mode
KEYTIMEOUT=20  # Reduces delay when typing 'jk'

# Make sure vi-mode is enabled
bindkey -v
# Old vi
# bindkey 'jk' vi-cmd-mode
# PS1+='${VIMODE}'
# #   '$' for normal insert mode
# #   a big red 'I' for command mode - to me this is 'NOT insert' because red
# function zle-line-init zle-keymap-select {
#     DOLLAR='%B%F{green}$%f%b '
#     GIANT_I='%B%F{red}N%f%b '
#     VIMODE="${${KEYMAP/vicmd/$GIANT_I}/(main|viins)/$DOLLAR}"
#     zle reset-prompt
# }
# zle -N zle-line-init
# zle -N zle-keymap-select

replace_strings() {
    # Define the colors
    RED='\033[1;31m'
    GREEN='\033[33m'
    NC='\033[0m' # No Color
    
    # Assign arguments to variables
    file_type=$1
    find_string=$2
    replace_string=$3
    
    echo "This will replace all instances of '$find_string' with '$replace_string' in all $file_type files."
    
    # Preview changes using sd's preview functionality
    echo "Preview of changes:"
    sd --preview "$find_string" "$replace_string" $(fd -e "$file_type")
    
    # Confirmation
    echo -n "Are you sure you want to continue? (y/n) "
    read answer
    if [ "$answer" != "${answer#[Yy]}" ]; then
        # Execute the replacement directly on the files found by fd
        sd "$find_string" "$replace_string" $(fd -e "$file_type")
        echo "Replacements completed."
    else
        echo "Operation cancelled."
    fi
}

# Usage: post_request <url> <file>
# <url>  - The URL to which the request will be sent.
# <file> - The path to the file containing the request body.
post() {
    if [[ $# -ne 2 ]]; then
        echo "Usage: post <url> <file>"
        return 1
    fi

    local url="$1"
    local file="$2"

    # Check if the file exists and is readable
    if [[ ! -r "$file" ]]; then
        echo "Cannot read file: $file"
        return 1
    fi

    # Use curl to send a POST request
    curl -X POST -H "Content-Type: application/json" -d @"$file" "$url"
}

help() {
  echo "Functions in .zshrc:"
  grep '()' ~/.zshrc

  echo "Alias in .zshrc:"
  grep 'alias' ~/.zshrc

  echo "Help in .zshrc:"
  grep -A1 '# HELP: ' ~/.zshrc
}

function lg() {
    command lazygit
}

function gitui() {
    command gitui
}

function ld() {
    command lazydocker
}


function zshconf() {
    cd ~/
    $EDITOR ~/.zshrc
    source ~/.zshrc
    cd -
}

export ZELLIX_MOD="$HOME/.dotfiles/zellix"

# editor in terminal
function te() {
    nu $ZELLIX_MOD/run.nu $ZELLIX_MOD/example $@
}

# editor in floating window, bind `floating` in your zellij to toggle
function pop {
    zellij ac rename-tab "$(basename "$(pwd)")"
    zellij run -f -x 0 -y 0 --width 100% --height 100% -- nu $ZELLIX_MOD/run.nu $ZELLIX_MOD/example
}

# edit dotfiles
function drc() {
  cd ~/.dotfiles/ && nu $ZELLIX_MOD/run.nu $ZELLIX_MOD/example
  cd -
}


# aider
function ai {
    # zellij ac rename-tab "ai $(basename "$(pwd)")"
    aider --no-attribute-author --no-attribute-committer --dark-mode --multi $@
}

export EDITOR=hx

export PREVIEW_SH=$HOME/.dotfiles/preview.sh

export XDG_CONFIG_HOME=~/.config/

### Fix for making Docker plugin work
# autoload -U compinit && compinit

zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

# macos stuff
#https://flaky.build/native-fix-for-applications-hiding-under-the-macbook-pro-notch
# defaults -currentHost delete -globalDomain NSStatusItemSelectionPadding
# defaults -currentHost delete -globalDomain NSStatusItemSpacing
# defaults -currentHost write -globalDomain NSStatusItemSelectionPadding -int 3
# defaults -currentHost write -globalDomain NSStatusItemSpacing -int 3

# macos stuff
# alias red="open /System/Library/CoreServices/ScreenSaverEngine.app"
 
# macos stuff
# lights() {
#     # Check if Vivid is running
#     if pgrep "Vivid" > /dev/null; then
#         # Close Vivid
#         pkill "Vivid"
#         # Open Flux
#         open -a "Flux"
#     else
#         # Check if Flux is running
#         if pgrep "Flux" > /dev/null; then
#             # Close Flux
#             pkill "Flux"
#             # Open Vivid
#             open -a "Vivid"
#         else
#             # Default action (You can decide to open either Vivid or Flux if none are running)
#             open -a "Vivid"
#         fi
#     fi
# }

# Kubectl

alias k9s='k9s -n all'

source <(fzf --zsh)

source <(kubectl completion zsh)

# Created by `pipx` on 2024-09-21 22:44:15
export PATH="$PATH:$HOME/.local/bin"
alias tfswitch="sudo /home/dries/.local/bin/tfswitch -i $HOME/.local/bin"

source ~/pyevn-default/bin/activate

export PATH=$HOME/.istioctl/bin:$PATH

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

  autoload -Uz compinit
  compinit
fi

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8	

CUDA_HOME=/usr/local/cuda
PATH=${CUDA_HOME}/bin${PATH:+:${PATH}}
# LD_LIBRARY_PATH=${CUDA_HOME}/lib64 ${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
# export LD_LIBRARY_PATH
export CUDA_HOME
export PATH

# cargo install du-dust
function dirsize() {
    dust $1
}

# function killold() {
#     local search_term=$1
#     if [[ -z $search_term ]]; then
#         echo "Usage: killold <search_term>"
#         return 1
#     fi

#     echo "Will kill these processes:"
#     ps -eo pid,etime,cmd | grep $search_term | grep -v grep
#     echo "\nProceed with kill? [y/N] "
#     read -q response
#     echo
    
#     if [[ $response =~ ^[Yy]$ ]]; then
#         echo "Killing processes..."
#         ps -eo pid,etime,cmd | grep $search_term | grep -v grep | awk '{print $1}' | xargs kill
#     else
#         echo "Operation cancelled"
#     fi
# }

# Gh Cli
export GH_PAGER=cat
eval "$(gh completion -s zsh)"
# BEGIN_AWS_SSO_CLI

# AWS SSO requires `bashcompinit` which needs to be enabled once and
# only once in your shell.  Hence we do not include the two lines:
#
# autoload -Uz +X compinit && compinit
# autoload -Uz +X bashcompinit && bashcompinit
#
# If you do not already have these lines, you must COPY the lines 
# above, place it OUTSIDE of the BEGIN/END_AWS_SSO_CLI markers
# and of course uncomment it

__aws_sso_profile_complete() {
     local _args=${AWS_SSO_HELPER_ARGS:- -L error}
    _multi_parts : "($(/home/linuxbrew/.linuxbrew/Cellar/aws-sso-cli/1.17.0/bin/aws-sso ${=_args} list --csv Profile))"
}

aws-sso-profile() {
    local _args=${AWS_SSO_HELPER_ARGS:- -L error}
    if [ -n "$AWS_PROFILE" ]; then
        echo "Unable to assume a role while AWS_PROFILE is set"
        return 1
    fi

    if [ -z "$1" ]; then
        echo "Usage: aws-sso-profile <profile>"
        return 1
    fi

    eval $(/home/linuxbrew/.linuxbrew/Cellar/aws-sso-cli/1.17.0/bin/aws-sso ${=_args} eval -p "$1")
    if [ "$AWS_SSO_PROFILE" != "$1" ]; then
        return 1
    fi
}

aws-sso-clear() {
    local _args=${AWS_SSO_HELPER_ARGS:- -L error}
    if [ -z "$AWS_SSO_PROFILE" ]; then
        echo "AWS_SSO_PROFILE is not set"
        return 1
    fi
    eval $(/home/linuxbrew/.linuxbrew/Cellar/aws-sso-cli/1.17.0/bin/aws-sso ${=_args} eval -c)
}

compdef __aws_sso_profile_complete aws-sso-profile
complete -C /home/linuxbrew/.linuxbrew/Cellar/aws-sso-cli/1.17.0/bin/aws-sso aws-sso

# END_AWS_SSO_CLI
eval 
MATANO_AC_ZSH_SETUP_PATH=/home/dries/.cache/matano/autocomplete/zsh_setup && test -f $MATANO_AC_ZSH_SETUP_PATH && source $MATANO_AC_ZSH_SETUP_PATH; # matano autocomplete setup

export NVM_DIR="$HOME/.config//nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

function aug-env {
  export GIT_SSH_COMMAND="ssh -i ~/.ssh/id_ed25519_auguria"
}

function u6-env {
  export GIT_SSH_COMMAND="ssh -i ~/.ssh/id_ed25519_unit6"
}

# default
aug-env

alias prc="gh pr comment --editor";
alias pre="gh pr comment --editor --edit-last";
alias prv="gh pr view --comments";
alias prw="gh pr view --web";

# Function to get PR URL and copy using OSC52
prl() {
  pr_url=$(gh pr view --json url --jq .url)
  if [ $? -eq 0 ]; then
    printf "\033]52;c;$(echo -n "$pr_url" | base64)\a"
    echo "PR URL copied to clipboard: $pr_url"
  else
    echo "Failed to get PR URL. Make sure you're in a git repository with an open PR."
  fi
}

export GOPRIVATE=github.com/auguria-io

# lldb-dap debugging and other
# $(brew --prefix)/opt/llvm/bin

# Function to edit PR description in your default editor
# If PR_NUMBER is empty, default behaviour follows
# Usage: predit [PR_NUMBER]
prb() {
  # Check if gh is installed
  if ! command -v gh &> /dev/null; then
    echo "Error: GitHub CLI (gh) is not installed. Please install it first."
    return 1
  fi

  # Check if a PR number was provided as an argument, otherwise use current branch
  if [ "$1" ]; then
    PR_SELECTOR="$1"
  else
    PR_SELECTOR=""
  fi

  # Create a temporary file
  TEMP_FILE=$(mktemp /tmp/pr-body-XXXXXX.md)

  # Get the current PR body and save to the temporary file
  echo "Fetching current PR description..."
  gh pr view $PR_SELECTOR --json body --jq .body > "$TEMP_FILE"

  if [ $? -ne 0 ]; then
    echo "Error: Failed to get PR description. Make sure you're in a repository with a PR or provide a valid PR number."
    rm "$TEMP_FILE"
    return 1
  fi

  # Get the original file modification time
  ORIGINAL_MTIME=$(stat -c %Y "$TEMP_FILE" 2>/dev/null || stat -f %m "$TEMP_FILE")

  # Open the temporary file in the default editor
  echo "Opening PR description in your default editor. Make your changes and save the file..."
  ${VISUAL:-${EDITOR:-vi}} "$TEMP_FILE"

  # Get the new file modification time
  NEW_MTIME=$(stat -c %Y "$TEMP_FILE" 2>/dev/null || stat -f %m "$TEMP_FILE")

  # Check if the file was modified
  if [ "$ORIGINAL_MTIME" = "$NEW_MTIME" ]; then
    echo "No changes were made. PR description not updated."
    rm "$TEMP_FILE"
    return 0
  fi

  # Update the PR body with the edited content
  echo "Updating PR description..."
  gh pr edit $PR_SELECTOR --body-file "$TEMP_FILE"

  if [ $? -eq 0 ]; then
    echo "PR description updated successfully!"
  else
    echo "Error: Failed to update PR description."
    echo "Your changes are saved in: $TEMP_FILE"
    return 1
  fi

  # Clean up
  rm "$TEMP_FILE"
}

# yazi
function c() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
