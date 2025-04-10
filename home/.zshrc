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

    # Assign the arguments to named variables
    file_type=$1
    find_string=$2
    replace_string=$3

    echo "This will replace all instances of '$find_string' with '$replace_string' in all $file_type files."

    # Find the files that contain the find_string
    files=$(grep -rl --include="*$file_type" "$find_string" .)

    echo "The following files will be affected:"
    echo "$files"

    echo "The following changes will be made:"
    pre_change=$(echo "$files" | xargs grep -n "$find_string")

    longest=0
    while IFS= read -r line
    do
        filename=$(echo $line | cut -d: -f1)
        length=${#filename}
        if (( length > longest ))
        then
            longest=$length
        fi
    done <<< "$pre_change"

    prev_filename=""
    while IFS= read -r line
    do
        filename=$(echo $line | cut -d: -f1)
        line_number=$(echo $line | cut -d: -f2)
        content=$(echo $line | cut -d: -f3- | sed -e 's/^[[:space:]]*//')

        # Calculate the number of leading spaces to align the replace_string
        leading_spaces=${content%%$find_string*}
        leading_spaces=${#leading_spaces}

				cut_before=$(echo "$content" | awk -v find="$find_string" '{split($0, a, find); print a[1]}')

				# Cut string after substring
				cut_after=$(echo "$content" | awk -v find="$find_string" '{split($0, a, find); print a[2]}')
        
        # Only print the filename if it is not the same as the previous one
        if [ "$filename" != "$prev_filename" ]
        then
            printf "\n%-$((longest+5))s\n" "$filename"
            prev_filename=$filename
        fi

        printf "%-3s:%s${RED}%s${NC}%s\n" "$line_number" "$cut_before" "$find_string" "$cut_after"
        printf "%-3s%*s ${RED} ~ %s${NC}\n" "" "$leading_spaces" "" "$replace_string"
    done <<< "$pre_change"

    echo -n "Are you sure you want to continue? (y/n) "
    read answer
    if [ "$answer" != "${answer#[Yy]}" ] ;then
        echo "$files" | xargs -I {} sed -i "" "s#$find_string#$replace_string#g" {}

        post_change=$(echo "$files" | xargs grep -n "$replace_string")
        if [ "$pre_change" != "$post_change" ]; then
            echo "Replacements were made. Here are the changes:"
            echo "$post_change"
        else
            echo "No replacements were made."
        fi
    else
        echo "Operation cancelled."
    fi
}

fname_grep() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "Usage: fname_grep <search_string> <file_type>"
        echo "Searches for a string in a given filetype within the current directory and its subdirectories."
        echo "Arguments:"
        echo "  <search_string>: The string to search for"
        echo "  <file_type>: The file type to search within"
        return 1
    fi

    local search_string="$1"
    local file_type="$2"

    # Get the length of the longest filename
    local longest_filename_length=$(grep -l "$search_string" --include="*.$file_type" -r . | awk '{ print length($0) }' | sort -nr | head -n 1)

    # Set the padding format based on the longest filename length
    local padding_format="%-${longest_filename_length}s"

    # Grep with padded filenames
    grep -H "$search_string" --include="*.$file_type" -r . | while IFS=: read -r filename content; do
        printf "$padding_format:$content\n" "$filename"
    done
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

  echo "Help in .zshrc:"
  grep -A1 '# HELP: ' ~/.zshrc
}

export ZELLIX_MOD="$HOME/dotfiles/zellix"

# function te() {
#     zellij ac rename-tab "hx $(basename "$(pwd)")"
#     nu $ZELLIX_MOD/run.nu $ZELLIX_MOD/example $@
# }

# function k9s() {
#     context=$(kubectl config current-context | cut -c 1-10);
#     zellij ac rename-tab "k9s $context";
#     command k9s
# }

function lg() {
    command lazygit
}

function gitui() {
    # zellij ac rename-tab "gitui"
    command gitui
}

function ld() {
    # zellij ac rename-tab "ld"
    command lazydocker
}


function zshconf() {
    # zellij ac rename-tab "zshconf"
    cd ~/
    $EDITOR ~/.zshrc
    source ~/.zshrc
    cd -
}

function drc() {
  # zellij ac rename-tab "dotfiles"
  cd ~/.dotfiles/ && nu $ZELLIX_MOD/run.nu $ZELLIX_MOD/example
  cd -
}


export ZELLIX_MOD="$HOME/.dotfiles/zellix"

function te() {
    # zellij ac rename-tab "hx $(basename "$(pwd)")"
    nu $ZELLIX_MOD/run.nu $ZELLIX_MOD/example $@
}

export EDITOR=hx

export PREVIEW_SH=$HOME/.dotfiles/preview.sh

# function fw() {
#   $EDITOR $(sk --ansi --cmd "rg --column --line-number --no-heading --color=always --smart-case --hidden $@" --delimiter ":" --height "100%" --preview "bat --color=always {1} --highlight-line {2}" --preview-window "up:60%:border")
# }




source /home/dries/.config/broot/launcher/bash/br

function ex() {
    selected_file=$(br)
    
    # Check if we got a valid file
    if [ $? -eq 0 ] && [ -n "$selected_file" ]; then
        if [ -f "$selected_file" ]; then
            ${EDITOR:-vim} "$selected_file"
        else
            echo "Error: Selected path is not a regular file: $selected_file"
            return 1
        fi
    else
        echo "No file selected or broot was cancelled"
        return 1
    fi
}


# function ex() {
#     FILE=$(br)
#     $EDITOR $FILE
# }

lights() {
    # Check if Vivid is running
    if pgrep "Vivid" > /dev/null; then
        # Close Vivid
        pkill "Vivid"
        # Open Flux
        open -a "Flux"
    else
        # Check if Flux is running
        if pgrep "Flux" > /dev/null; then
            # Close Flux
            pkill "Flux"
            # Open Vivid
            open -a "Vivid"
        else
            # Default action (You can decide to open either Vivid or Flux if none are running)
            open -a "Vivid"
        fi
    fi
}
export XDG_CONFIG_HOME=~/.config/

### Fix for making Docker plugin work
# autoload -U compinit && compinit

zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

openpodport() {
    pod_name=$1
    internal_port=$2

    if [ -z "$pod_name" ] || [ -z "$internal_port" ]; then
        echo "Usage: open_pod_port_in_brave <pod_name> <internal_port>"
        return 1
    fi

    # Find the container ID using the pod name
    container_id=$(docker ps --filter "name=$pod_name" --format "{{.ID}}")

    if [ -z "$container_id" ]; then
        echo "Container not found for pod: $pod_name"
        return 1
    fi

    # Extract the mapped port
    mapped_port=$(docker port $container_id $internal_port | cut -d ':' -f 2)

    if [ -z "$mapped_port" ]; then
        echo "No port found mapped to $internal_port for pod: $pod_name"
        return 1
    fi

    # Construct the URL
    url="http://localhost:$mapped_port"

    # Open the URL in Brave Browser
    if open -a "Brave Browser" $url; then
        echo "Opened $url in Brave Browser."
    else
        echo "Failed to open Brave Browser. Is it installed?"
    fi
}

dotenv() {
	export $(cat .env | grep -v ^# | xargs);
}

# eval "$(pyenv init -)"

my-backward-word () {
    # Add colon, comma, single/double quotes to word chars
    local WORDCHARS='*?_-.[]~=/&;!#$%^(){}<>:,"'"'"
    zle backward-word
}
my-forward-word () {
    # Add colon, comma, single/double quotes to word chars
    local WORDCHARS='*?_-.[]~=/&;!#$%^(){}<>:,"'"'"
    zle forward-word
}

zle -N my-backward-word
zle -N my-forward-word
bindkey "[D" my-backward-word
bindkey "[C" my-forward-word

#https://flaky.build/native-fix-for-applications-hiding-under-the-macbook-pro-notch
# defaults -currentHost delete -globalDomain NSStatusItemSelectionPadding
# defaults -currentHost delete -globalDomain NSStatusItemSpacing
# defaults -currentHost write -globalDomain NSStatusItemSelectionPadding -int 3
# defaults -currentHost write -globalDomain NSStatusItemSpacing -int 3
alias avim="NVIM_APPNAME=AstroNvim nvim"
alias cachesite="wget --mirror --convert-links --adjust-extension --page-requisites --no-parent $1"

alias z="zoxide"
alias red="open /System/Library/CoreServices/ScreenSaverEngine.app"

# Kubectl

alias k9s='k9s -n all'


source <(fzf --zsh)

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

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

alias td="$EDITOR ~/.todo.md"
alias cmds="$EDITOR ~/.cmds.md"

CUDA_HOME=/usr/local/cuda
PATH=${CUDA_HOME}/bin${PATH:+:${PATH}}
# LD_LIBRARY_PATH=${CUDA_HOME}/lib64 ${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
# export LD_LIBRARY_PATH
export CUDA_HOME
export PATH

# Add this to your ~/.zshrc
function dirsize() {
    local target_dir="${1:-.}"  # Use passed path or current dir (.)
    local abs_path="$(cd "$target_dir" 2>/dev/null && pwd)"
    
    if [ $? -ne 0 ]; then
        echo "Error: Directory '$target_dir' does not exist or is not accessible"
        return 1
    fi
    
    echo "Size breakdown for: $abs_path"
    echo "----------------------------------------"
    (cd "$abs_path" && du -sh -- */ 2>/dev/null) | sort -hr
}

function killold() {
    local search_term=$1
    if [[ -z $search_term ]]; then
        echo "Usage: killold <search_term>"
        return 1
    fi

    echo "Will kill these processes:"
    ps -eo pid,etime,cmd | grep $search_term | grep -v grep
    echo "\nProceed with kill? [y/N] "
    read -q response
    echo
    
    if [[ $response =~ ^[Yy]$ ]]; then
        echo "Killing processes..."
        ps -eo pid,etime,cmd | grep $search_term | grep -v grep | awk '{print $1}' | xargs kill
    else
        echo "Operation cancelled"
    fi
}

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

function ai {
    # zellij ac rename-tab "ai $(basename "$(pwd)")"
    aider --no-attribute-author --no-attribute-committer --dark-mode --multi $@
}

function pop {
    zellij ac rename-tab "$(basename "$(pwd)")"
    zellij run -f -x 0 -y 0 --width 100% --height 100% -- nu $ZELLIX_MOD/run.nu $ZELLIX_MOD/example
}

alias prc="gh pr comment --editor";
alias pre="gh pr comment --editor --edit-last";
alias prv="gh pr view --comments";
alias prw="gh pr view --web";

export GOPRIVATE=github.com/auguria-io

# lldb-dap debugging and other
# $(brew --prefix)/opt/llvm/bin
