# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

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
plugins=(git docker-compose)

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

# Italics
alias tm="env TERM=screen-256color tmux"
alias tx="env TERM=screen-256color tmux"


### QOL Shortcuts

alias zshconf="avim ~/.zshrc; source ~/.zshrc"

alias llt="ls -lat"

alias clean="mv ~/Desktop/* ~/not_desktop"
rmds () {
	rm $(find . | grep '\.DS_Store')
}

alias lg="lazygit"
alias ld="lazydocker"
# alias air='~/.air'

export KEY_DIR=~/dev/secrutiny/keys
export SUY=~/dev/secrutiny/
alias suy=~/dev/secrutiny/

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
source $HOME/.cargo/env

# GCP
# PATH for the Google Cloud SDK.
if [ -f '/Users/dries/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/dries/google-cloud-sdk/path.zsh.inc'; fi
# shell command completion for gcloud.
if [ -f '/Users/dries/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/dries/google-cloud-sdk/completion.zsh.inc'; fi

# Terraform
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform

# AZ CLI 
# HOMEBREW_PREFIX="$(brew --prefix)"
HOMEBREW_PREFIX="/opt/homebrew"
source "$HOMEBREW_PREFIX/etc/bash_completion.d/az"

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
export PATH="$HOME/go/bin/:$PATH"


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


bindkey 'jk' vi-cmd-mode
PS1+='${VIMODE}'
#   '$' for normal insert mode
#   a big red 'I' for command mode - to me this is 'NOT insert' because red
function zle-line-init zle-keymap-select {
    DOLLAR='%B%F{green}$%f%b '
    GIANT_I='%B%F{red}N%f%b '
    VIMODE="${${KEYMAP/vicmd/$GIANT_I}/(main|viins)/$DOLLAR}"
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

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

export EDITOR=lvim

function chron() {
    local inputString="$1"
    local baseURL="https://mercury-europe-west2.backstory.chronicle.security/rawLogScanResults?searchQuery=SUBSTITUTEHERE&cs=0&sources=Apache,Arcsight%20CEF,Auth0,Azure%20AD%20Organizational%20Context,Azure%20DevOps%20Audit,CrowdStrike%20Falcon,CSG%20Singleview,CSV%20Custom%20IOC,Digital%20Shadows%20Indicators,Elastic%20Windows%20Event%20Log%20Beats,F5%20ASM,FortiGate,Juniper,Linux%20Auditing%20System%20(AuditD),Microsoft%20Defender%20for%20Endpoint,Microsoft%20Graph%20API%20Alerts,Netscout,Netscout%20Arbor%20Sightline,Office%20365,Onesys,Osirium%20PAM,Pulse%20Secure,Rapid7%20Insight,Shrubbery%20TACACS%2B,Symantec%20Web%20Security%20Service,UDM,Unix%20system,VMware%20ESXi&regex=1&referenceTime=2023-08-17T10:25:00.000Z&startTime=2023-07-19T00:00:00.000Z&endTime=2023-07-21T23:30:00.000Z&selectedList=RawLogScanViewTimeline"

    # Substitute the input string in place of the placeholder and open the URL in Brave browser.
    local finalURL=$(echo "$baseURL" | sed "s/SUBSTITUTEHERE/${inputString}/")
    open -a "Brave Browser" "$finalURL"
}

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

eval "$(pyenv init -)"

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
source <(kubectl completion zsh)

alias k9s='k9s -n all'
