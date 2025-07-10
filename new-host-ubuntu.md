# Setting up a new ubuntu server

## Connect

```sh
ssh dries@65.108.46.236 -i ~/.ssh/id_ed25519_unit6
```

### First setup (user account)

While logged in as root, setup a new user account by copying this script and pasting

```sh
sudo bash <<'EOF'
# --- EDIT THIS LINE ---
NEW_USER="dries"
# --------------------

# Exit immediately if a command exits with a non-zero status.
set -e

echo "--- Starting setup for new user: $NEW_USER ---"

# Check if user already exists
if id "$NEW_USER" &>/dev/null; then
    echo "User $NEW_USER already exists. Exiting."
    exit 1
fi

# Create the new user with a home directory and bash shell
echo "Creating user '$NEW_USER'..."
useradd -m -s /bin/bash "$NEW_USER"

# Add the new user to the 'sudo' group for admin privileges
echo "Adding '$NEW_USER' to the sudo group..."
usermod -aG sudo "$NEW_USER"

# Create the .ssh directory and set correct permissions
USER_HOME=$(eval echo ~$NEW_USER)
echo "Setting up SSH directory at $USER_HOME/.ssh..."
mkdir -p "$USER_HOME/.ssh"
chmod 700 "$USER_HOME/.ssh"

# Copy the root user's authorized SSH keys to the new user
# This allows you to log in as the new user with the same SSH key you used for root
echo "Copying root's authorized_keys..."
cp /root/.ssh/authorized_keys "$USER_HOME/.ssh/authorized_keys"

# Set correct ownership and permissions for the new user's SSH files
echo "Setting ownership and permissions for SSH files..."
chown -R "$NEW_USER:$NEW_USER" "$USER_HOME/.ssh"
chmod 600 "$USER_HOME/.ssh/authorized_keys"

# Configure passwordless sudo for the new user
echo "Configuring passwordless sudo for '$NEW_USER'..."
echo "$NEW_USER ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/$NEW_USER"
chmod 0440 "/etc/sudoers.d/$NEW_USER"

# Disable password login for the user account itself
echo "Disabling password login for user '$NEW_USER'..."
usermod -p '*' "$NEW_USER"

# Harden SSH configuration to disable password authentication for the whole server
echo "Hardening server-wide SSH configuration..."
sed -i -E 's/^#?PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i -E 's/^#?ChallengeResponseAuthentication yes/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config

# Restart the SSH service to apply changes
echo "Restarting SSH service..."
systemctl restart ssh

echo "---"
echo "✅ Setup complete for user '$NEW_USER'."
echo "You can now log in using: ssh $NEW_USER@<your_server_ip>"
echo "IMPORTANT: Test this new login from a separate terminal before closing your root session."
echo "---"

EOF
```

## Setup SSH account (in new account)

```
bash <<'EOF'
# --- EDIT THIS LIST ---
# Format: "org_name:your_email@example.com"
# Add as many lines as you need inside the parentheses.
ORG_EMAILS=(
    "unit6:sander@unit-6.net"
    "auguria:sverheijen@auguria.io"
)
# ----------------------

# Exit immediately if a command fails
set -e

# --- SCRIPT LOGIC ---

# Ensure the .ssh directory exists with the correct permissions
echo "-> Ensuring ~/.ssh directory exists..."
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# Path to the SSH config file
SSH_CONFIG_FILE="$HOME/.ssh/config"
touch "$SSH_CONFIG_FILE" # Ensure the file exists before we append to it

# Function to create and setup an SSH key
create_ssh_key() {
    local org=$1
    local email=$2
    local key_file="$HOME/.ssh/id_ed25519_$org"

    if [ -f "$key_file" ]; then
        echo "-> Key for '$org' already exists. Skipping key generation."
    else
        echo "-> Generating new ED25519 key for '$org'..."
        ssh-keygen -t ed25519 -C "$email" -f "$key_file" -q -N ""
    fi
    
    # Add key to the running ssh-agent
    ssh-add "$key_file" > /dev/null 2>&1
    
    echo "🔑 Public key for '$org' ($email):"
    cat "${key_file}.pub"
    echo
}

# Function to append SSH config, checking for duplicates first
append_ssh_config() {
    local org=$1
    local host_entry="Host github.com-$org"

    if grep -q "$host_entry" "$SSH_CONFIG_FILE"; then
        echo "-> SSH config for '$org' already exists. Skipping."
    else
        echo "-> Adding SSH config for '$org' to $SSH_CONFIG_FILE..."
        {
            echo ""
            echo "$host_entry"
            echo "    HostName github.com"
            echo "    User git"
            echo "    IdentityFile ~/.ssh/id_ed25519_$org"
            echo "    IdentitiesOnly yes"
        } >> "$SSH_CONFIG_FILE"
    fi
}

# Start ssh-agent in the background if not already running
if [ -z "$SSH_AGENT_PID" ]; then
    echo "-> Starting ssh-agent..."
    eval "$(ssh-agent -s)" > /dev/null
fi

# --- MAIN EXECUTION ---
echo "---"
echo "Starting SSH key setup for GitHub..."
echo "---"

# Create keys and update config for each organization
for org_email in "${ORG_EMAILS[@]}"; do
    IFS=':' read -r org email <<< "$org_email"
    create_ssh_key "$org" "$email"
    append_ssh_config "$org"
    echo "---"
done

# --- FINAL INSTRUCTIONS ---
echo "✅ Setup Complete!"
echo
echo "NEXT STEPS:"
echo "1. Copy each public key printed above (the lines starting with 'ssh-ed25519...')."
echo "2. Go to your GitHub account settings for that organization/profile."
echo "3. Navigate to 'SSH and GPG keys' and add the new SSH key."
echo
echo "To use a specific key, clone or set your remote URL like this:"
echo "   git clone git@github.com-ORG_NAME:USERNAME/REPO.git"
echo
echo "For example, for the 'unit6' organization:"
echo "   git clone git@github.com-unit6:driesvints/my-repo.git"
echo

EOF
```

## Zsh, Fzf

```
bash <<'EOF'
# This script automates the setup of a modern Zsh environment on Linux using
# the native package manager, Oh My Zsh, and essential plugins.
#
# It will:
# 1. Detect the system's package manager (apt or dnf).
# 2. Install Zsh, build-essentials, and other key tools.
# 3. Install Oh My Zsh.
# 4. Install useful tools (bat, eza, fzf).
# 5. Install key Zsh plugins for autosuggestions, syntax highlighting, and completions.
# 6. Automatically configure the .zshrc file to enable all plugins and aliases.

# Exit immediately if any command fails
set -e

# --- SCRIPT LOGIC ---

# 1. Detect Package Manager and set commands
PACKAGE_MANAGER=""
UPDATE_CMD=""
INSTALL_CMD=""
ESSENTIALS_PKG=""

if command -v apt &> /dev/null; then
    echo "-> Debian/Ubuntu based system detected (using apt)."
    PACKAGE_MANAGER="apt"
    UPDATE_CMD="sudo apt update"
    INSTALL_CMD="sudo apt install -y"

    ESSENTIALS_PKG="build-essential"
elif command -v dnf &> /dev/null; then
    echo "-> Fedora/RHEL based system detected (using dnf)."
    PACKAGE_MANAGER="dnf"
    UPDATE_CMD="sudo dnf check-update"
    INSTALL_CMD="sudo dnf install -y"
    ESSENTIALS_PKG="@development-tools"
else
    echo "-> Could not determine package manager. Exiting."
    exit 1
fi

# Update package lists
echo "-> Updating package lists..."
$UPDATE_CMD

# 2. Install Zsh and essential packages
echo "-> Installing Zsh, git, curl, and build tools..."
$INSTALL_CMD zsh git curl $ESSENTIALS_PKG

# 3. Change the default shell to Zsh (requires user password)
if [ "$SHELL" != "/bin/zsh" ] && [ "$SHELL" != "/usr/bin/zsh" ]; then
    echo "-> Changing default shell to Zsh. This will require your password."
    # chsh may not be in the path for some users, so we check common locations
    if command -v chsh &>/dev/null; then
        chsh -s $(which zsh)
    else
        echo "chsh command not found. Please change your shell manually with 'sudo usermod -s \$(which zsh) \$USER'"
    fi
else
    echo "-> Default shell is already Zsh. Skipping."
fi

# 4. Install Oh My Zsh (if not already installed)
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "-> Oh My Zsh is already installed. Skipping installation."
else
    echo "-> Oh My Zsh not found. Installing now..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# 5. Install useful command-line tools
echo "-> Installing essential tools (bat, eza, fzf)..."
# bat is often 'batcat' on Debian/Ubuntu to avoid conflicts
BAT_CMD="bat"
if command -v apt &> /dev/null; then
    $INSTALL_CMD batcat # On Debian/Ubuntu, the binary is batcat
    BAT_CMD="batcat"
else
    $INSTALL_CMD bat
fi
$INSTALL_CMD eza fzf

# 6. Install Zsh plugins
echo "-> Installing Zsh plugins..."
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
PLUGINS_DIR="$ZSH_CUSTOM/plugins"

clone_plugin() {
    local repo_url=$1
    local plugin_dir=$2
    if [ -d "$plugin_dir" ]; then
        echo "   - Plugin $(basename $plugin_dir) already exists. Skipping clone."
    else
        echo "   - Cloning $(basename $plugin_dir)..."
        git clone --depth=1 "$repo_url" "$plugin_dir"
    fi
}

clone_plugin "https://github.com/zsh-users/zsh-autosuggestions" "$PLUGINS_DIR/zsh-autosuggestions"
clone_plugin "https://github.com/zsh-users/zsh-syntax-highlighting" "$PLUGINS_DIR/zsh-syntax-highlighting"
clone_plugin "https://github.com/zsh-users/zsh-completions" "$PLUGINS_DIR/zsh-completions"

# 7. Activate plugins and aliases in .zshrc
echo "-> Configuring .zshrc file..."
ZSHRC_FILE="$HOME/.zshrc"

PLUGINS_TO_ENABLE=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-completions
)
PLUGIN_STRING="plugins=($(printf " %s" "${PLUGINS_TO_ENABLE[@]}"))"

if grep -q "^plugins=(" "$ZSHRC_FILE"; then
    sed -i.bak "s/^plugins=(.*)/${PLUGIN_STRING}/" "$ZSHRC_FILE"
    echo "   - Updated existing plugins list in $ZSHRC_FILE."
else
    echo "${PLUGIN_STRING}" >> "$ZSHRC_FILE"
    echo "   - Added plugins list to $ZSHRC_FILE."
fi

# Add custom aliases for the new tools
if ! grep -q "# Custom Aliases" "$ZSHRC_FILE"; then
    echo "-> Adding custom aliases for new tools..."
    {
        echo ''
        echo '# Custom Aliases'
        echo "alias cat=\"$BAT_CMD\""
        echo 'alias ls="eza --icons"'
        echo 'alias ll="eza -l --icons"'
        echo 'alias la="eza -la --icons"'
    } >> "$ZSHRC_FILE"
fi

# Add fzf keybindings
if ! grep -q "[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh" "$ZSHRC_FILE"; then
    echo "-> Adding fzf keybindings to .zshrc..."
    echo '[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh' >> "$ZSHRC_FILE"
fi

echo
echo "---"
echo "✅ Setup Complete!"
echo "---"
echo

# --- FINAL INSTRUCTIONS ---
echo "NEXT STEPS:"
echo
echo "1. Log out and log back in for the new default shell to take effect."
echo "   Alternatively, you can start a new Zsh session immediately by running:"
echo "   exec zsh"
echo
echo "2. Enjoy your new, supercharged Zsh shell!"
echo

EOF
```

## Install direnv to control git ssh keys

```
bash <<'EOF'
# This script automates the installation and configuration of direnv.
#
# It will:
# 1. Create a user-writable binary directory (~/.local/bin).
# 2. Add this directory to the shell's PATH configuration.
# 3. Install direnv into this directory.
# 4. Hook direnv into your shell's configuration file (.bashrc or .zshrc).
# 5. Create project directories with specific .envrc files for SSH keys.

# Exit immediately if any command fails
set -e

# --- SCRIPT LOGIC ---

# This function adds a line to a file if it's not already there.
add_line_if_missing() {
    local line_to_add=$1
    local target_file=$2
    if [ -f "$target_file" ] && ! grep -Fxq "$line_to_add" "$target_file"; then
        echo "   - Adding configuration to $target_file..."
        {
            echo ""
            echo "$line_to_add"
        } >> "$target_file"
    fi
}

# 1. & 2. Ensure a user-writable bin directory exists and is in the PATH.
echo "-> Ensuring ~/.local/bin exists and is in your PATH..."
BIN_DIR="$HOME/.local/bin"
mkdir -p "$BIN_DIR"

# Add the user's bin directory to PATH for both .bashrc and .zshrc
add_line_if_missing 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.bashrc"
add_line_if_missing 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.zshrc"

# Export the PATH for the current script session
export PATH="$BIN_DIR:$PATH"


# 3. Install direnv if it's not already installed
if command -v direnv &> /dev/null; then
    echo "-> direnv is already installed. Skipping installation."
else
    echo "-> direnv not found. Installing now..."
    # Tell the installer exactly where to put the binary
    export bin_path="$BIN_DIR"
    curl -sfL https://direnv.net/install.sh | bash
fi

# 4. Hook direnv into the shell
echo "-> Setting up direnv hook..."
add_line_if_missing 'eval "$(direnv hook bash)"' "$HOME/.bashrc"
add_line_if_missing 'eval "$(direnv hook zsh)"' "$HOME/.zshrc"


# 5. Create directories and their respective .envrc files
echo "-> Creating development directories and .envrc files..."

declare -A DIRS
DIRS=( ["u6"]="unit6" ["aug"]="auguria" )

for dir_short in "${!DIRS[@]}"; do
    org_name=${DIRS[$dir_short]}
    TARGET_DIR="$HOME/dev/$dir_short"
    ENVRC_FILE="$TARGET_DIR/.envrc"
    SSH_KEY_PATH="~/.ssh/id_ed25519_$org_name"

    echo "   - Setting up directory: $TARGET_DIR"
    mkdir -p "$TARGET_DIR"

    # Create the .envrc file with the specific GIT_SSH_COMMAND
    # Note: Using single quotes to prevent ~ from expanding immediately
    echo "export GIT_SSH_COMMAND='ssh -i $SSH_KEY_PATH'" > "$ENVRC_FILE"
done

echo
echo "---"
echo "✅ Setup Complete!"
echo "---"
echo

# --- FINAL INSTRUCTIONS ---
echo "NEXT STEPS:"
echo
echo "1. Restart your shell for all changes to take effect."
echo "   You can do this by opening a new terminal window or by running:"
echo "   exec \"\$SHELL\""
echo
echo "2. Navigate into one of the new directories:"
echo "   cd ~/dev/u6/"
echo
echo "3. direnv will block you and ask for permission. Run the following command to allow it:"
echo "   direnv allow"
echo
echo "4. Repeat for the other directory:"
echo "   cd ~/dev/aug/ && direnv allow"
echo
echo "IMPORTANT: This script assumes you have already created the SSH keys"
echo "at ~/.ssh/id_ed25519_unit6 and ~/.ssh/id_ed25519_auguria. If not, please generate them."
echo

EOF
```

## Install Dev tools

```sh
bash <<'EOF'
# This script automates the setup of a complete development environment on LINUX.
#
# It will:
# 1. Install Homebrew (Linuxbrew) if it is not already present.
# 2. Configure the shell environment for Homebrew.
# 3. Install a comprehensive list of CLI tools, developer utilities, and languages.
# 4. Correctly configure htop to run without sudo.
# 5. Use 'uv' for Python environment management.
# 6. Provide clear instructions for required manual follow-up steps.

# Exit immediately if a command fails
set -e

# --- 1. INSTALL HOMEBREW (LINUXBREW) ---

# Detect the correct shell configuration file
SHELL_CONFIG_FILE=""
if [ -f "$HOME/.zshrc" ]; then
    SHELL_CONFIG_FILE="$HOME/.zshrc"
elif [ -f "$HOME/.bashrc" ]; then
    SHELL_CONFIG_FILE="$HOME/.bashrc"
else
    # Default to .profile if the others don't exist
    SHELL_CONFIG_FILE="$HOME/.profile"
    touch "$SHELL_CONFIG_FILE"
fi

if ! command -v brew &> /dev/null; then
  echo "-> Homebrew not found. Installing now (this may take a while)..."
  # Use the official non-interactive installer
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  echo "-> Adding Homebrew to your shell environment..."
  # Add brew to the shell config file to make it permanent
  (echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> "$SHELL_CONFIG_FILE"
  # Add brew to the PATH for the current script session
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
else
  echo "-> Homebrew is already installed. Updating..."
  brew update
fi

# --- 2. INSTALL PACKAGES WITH HOMEBREW ---

# Define package lists based on categories
CORE_UTILS=(
  git git-lfs gh zstd sd fd bat eza ripgrep the_silver_searcher fzf
  difftastic bottom htop dust tmux zellij yazi broot lazygit gitui
  yamllint yq gomplate croc mosh pandoc duckdb
)

DEV_TOOLS=(
  awscli aws-sam-cli aws-sso-cli
  kubectl minikube k9s eksctl helm
  dive neovim helix terraform-ls
  ollama aichat
)

LANG_GO=(
  go gopls protobuf
)

LANG_RUST=(
  rustup-init zig
)

LANG_JAVA=(
  openjdk@17 gradle jdt-ls kotlin-language-server
)

LANG_NODE=(
  node yarn typescript-language-server yaml-language-server aws-cdk
)

LANG_PYTHON=(
  python uv python@3.11 python@3.12
  ruff python-lsp-server jedi-language-server
  playwright cfn-lint scrapy jupyterlab
)


echo "-> Installing Core CLI Utilities..."
brew install "${CORE_UTILS[@]}"

echo "-> Installing Development & DevOps Tools..."
brew install "${DEV_TOOLS[@]}"

echo "-> Installing Go Language Tools..."
brew install "${LANG_GO[@]}"

echo "-> Installing Rust Language Tools..."
brew install "${LANG_RUST[@]}"

echo "-> Installing Java Language Tools..."
brew install "${LANG_JAVA[@]}"

echo "-> Installing Node.js Language Tools..."
brew install "${LANG_NODE[@]}"

echo "-> Installing Python Language Tools..."
brew install "${LANG_PYTHON[@]}"


# --- 3. POST-INSTALL CONFIGURATION ---

echo "-> Performing post-install configurations..."

# Set SUID bit for htop to allow it to run without sudo
echo "   - Configuring htop to run without needing 'sudo'..."
# This command finds the htop binary installed by brew and gives it the necessary permissions
sudo chmod u+s "$(brew --prefix htop)/bin/htop"

# --- 4. CONFIGURE SHELL ENVIRONMENT ---

echo "-> Configuring shell environment with aliases and fzf setup..."

# Add fzf keybindings
if ! grep -q "fzf/shell/key-bindings" "$SHELL_CONFIG_FILE"; then
    echo "   - Adding fzf keybindings to $SHELL_CONFIG_FILE..."
    {
        echo ""
        echo "# fzf setup"
        echo '[ -f /home/linuxbrew/.linuxbrew/opt/fzf/shell/completion.zsh ] && source /home/linuxbrew/.linuxbrew/opt/fzf/shell/completion.zsh'
        echo '[ -f /home/linuxbrew/.linuxbrew/opt/fzf/shell/key-bindings.zsh ] && source /home/linuxbrew/.linuxbrew/opt/fzf/shell/key-bindings.zsh'
    } >> "$SHELL_CONFIG_FILE"
fi

# Add custom aliases
if ! grep -q "# Custom Aliases" "$SHELL_CONFIG_FILE"; then
    echo "   - Adding modern aliases to $SHELL_CONFIG_FILE..."
    {
        echo ''
        echo '# Custom Aliases'
        echo 'alias ls="eza --icons"'
        echo 'alias ll="eza -l --icons --git"'
        echo 'alias cat="bat -p"'
        echo 'alias find="fd"'
    } >> "$SHELL_CONFIG_FILE"
else
    echo "-> Skipping alias configuration (already present)."
fi


# --- 5. FINAL INSTRUCTIONS ---
echo
echo "-------------------------------------------"
echo "✅ Environment Setup Complete!"
echo "-------------------------------------------"
echo
echo "🔴 IMPORTANT - MANUAL STEPS REQUIRED:"
echo
echo "1. Restart your shell for all changes to take effect."
echo "   You can do this by opening a new terminal or running: exec \$SHELL"
echo
echo "2. Set up Rust:"
echo "   - Run 'rustup-init' and follow the prompts to install the toolchain."
echo "   - Then run: rustup component add rust-analyzer clippy"
echo
echo "3. Set up a Python Environment with uv (Example):"
echo "   - Create a project folder: mkdir my-python-project && cd my-python-project"
echo "   - Create a virtual environment with a specific python: uv venv -p python3.12"
echo "   - Activate the environment: source .venv/bin/activate"
echo "   - Install packages: uv pip install ruff numpy pandas"
echo
echo "4. Set up Java Environment:"
echo "   - To use OpenJDK 17, you may need to add it to your PATH."
echo "   - Add the following to your shell config file ($SHELL_CONFIG_FILE):"
echo '   export PATH="/home/linuxbrew/.linuxbrew/opt/openjdk@17/bin:$PATH"'
echo
echo "5. Note on 'nil' (Nix Language Server):"
echo "   - This tool was not installed because it is not in the default Homebrew repository."
echo "   - It requires manual installation, often via a custom tap or from source."
echo
echo "Enjoy your new development environment!"
echo
EOF```
