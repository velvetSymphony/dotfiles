#!/usr/bin/env bash

set -eu -o pipefail

RED='\033[[0;31m'
GREEN='\033[[0;32m'
YELLOW='\033[[1;33m'
BLUE='\033[[0;34m'
NC='\033[[0m'

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

detect_os() {
    # Check if running in WSL
    # TODO: Redo this
    if grep -qi microsoft /proc/version 2>/dev/null || [[ -n "$WSL_DISTRO_NAME" ]; then
        OS="wsl-ubuntu"
        print_status "Detected WSL Ubuntu environment"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command_exists apt-get; then
            OS="ubuntu"
        elif command_exists yum; then
            OS="centos"
        elif command_exists pacman; then
            OS="arch"
        else
            OS="linux"
        fi
    elif [[[[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
    else
        OS="unknown"
    fi
}

# TODO: Redo this as well
install_package() {
    local package=$1
    print_status "Installing $package..."

    case $OS in
        ubuntu|wsl-ubuntu)
            sudo apt-get update && sudo apt update && sudo apt upgrade -y
            sudo apt-get install -y $package build-essential jq nala
            ;;
        centos)
            sudo yum install -y $package
            ;;
        arch)
            sudo pacman -S --noconfirm $package
            ;;
        macos)
            if command_exists brew; then
                brew install $package
            else
                print_error "Homebrew not found. Please install Homebrew first."
                return 1
            fi
            ;;
        *)
            print_error "Unsupported OS. Please install $package manually."
            return 1
            ;;
    esac
}

main() {
    print_status "Starting terminal bootstrap script"
    detect_os
    print_status "Detected OS: $OS"

    print_status "Installing prerequisites"

    if ! command_exists zsh; then
        print_status "Installing zsh..."
        install_package zsh
    else
        print_success "zsh is already installed"
    fi

    if ! command_exists git; then
        print_status "Installing git..."
        install_package git
    else
        print_success "git is already installed"
    fi

    if ! command_exists curl; then
        print_status "Installing curl..."
        install_package curl
    else
        print_success "curl is already installed"
    fi

    # Oh My Zsh
    #TODO: Find ways to make unattended installs "safer"
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        print_status "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        print_success "Oh My Zsh installed"
    else
        print_success "Oh My Zsh is already installed"
    fi

    # Powerlevel10k theme
    if [[ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]]; then
        print_status "Installing Powerlevel10k theme..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
        print_success "Powerlevel10k installed"
    else
        print_success "Powerlevel10k is already installed"
    fi

    # fzf
    if ! command_exists fzf; then
        print_status "Installing fzf..."
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install --all --no-bash --no-fish
        print_success "fzf installed"
    else
        print_success "fzf is already installed"
    fi

    curl -LsSf https://astral.sh/uv/install.sh | sh

    # ripgrep
    if ! command_exists rg; then
        print_status "Installing ripgrep..."
        case $OS in
            ubuntu|wsl-ubuntu)
                install_package ripgrep
                ;;
            *)
                install_package ripgrep
                ;;
        esac
    else
        print_success "ripgrep is already installed"
    fi

    # bat
    if ! command_exists bat; then
        print_status "Installing bat..."
        case $OS in
            ubuntu|wsl-ubuntu)
                install_package bat
                # Create symlink for bat if it's installed as batcat
                if command_exists batcat && ! command_exists bat; then
                    sudo ln -sf $(which batcat) /usr/local/bin/bat
                fi
                ;;
            *)
                install_package bat
                ;;
        esac
    else
        print_success "bat is already installed"
    fi

    # exa/eza (ls)
    if ! command_exists eza && ! command_exists exa; then
        print_status "Installing eza..."
        case $OS in
            ubuntu|wsl-ubuntu)
                # Install eza from GitHub releases for Ubuntu/WSL
                if ! command_exists eza; then
                    print_status "Installing eza from GitHub releases..."
                    wget -q https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz -O /tmp/eza.tar.gz
                    sudo tar -xzf /tmp/eza.tar.gz -C /usr/local/bin
                    rm /tmp/eza.tar.gz
                fi
                ;;
            macos)
                install_package eza
                ;;
            *)
                print_warning "eza installation not supported for this OS, skipping..."
                ;;
        esac
    else
        print_success "eza/exa is already installed"
    fi

    # uv
    # https://github.com/astral-sh/uv/issues/13074 is what I wanted to initially do
    if ! command_exists uv; then
        print_status "Installing uv..."
        curl -LsSf https://astral.sh/uv/install.sh | sh
        print_success "uv installed"
        uv self update
        print_success "uv updated"
    else
        print_success "uv is already installed"
    fi

    print_status "Installing zsh plugins..."

    # zsh-autosuggestions
    if [[ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
        print_success "zsh-autosuggestions installed"
    else
        print_success "zsh-autosuggestions already installed"
    fi

    # zsh-syntax-highlighting
    if [[ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
        print_success "zsh-syntax-highlighting installed"
    else
        print_success "zsh-syntax-highlighting already installed"
    fi

    print_status "Configuring .zshrc..."

    # Backup existing .zshrc if it exists
    if [[ -f "$HOME/.zshrc" ]]; then
        cp "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"
        print_status "Backed up existing .zshrc"
    fi

    # Symlink zshrc in $HOME to this repo
    # TODO: Explore $ZDOTDIR https://github.com/mattmc3/zdotdir
    ln -s ../zsh/zshrc_base $HOME/.zshrc
    print_success ".zshrc configured"

    # Change default shell to zsh
    if [[ "$SHELL" != *"zsh"* ]]; then
        print_status "Changing default shell to zsh..."
        if command_exists chsh; then
            chsh -s $(which zsh)
            print_success "Default shell changed to zsh"
            print_warning "Open new terminal (log out and log back in) for changes to take effect"
        else
            print_warning "chsh not available. Manually change your default shell to zsh"
        fi
    else
        print_success "zsh is already the default shell"
    fi

    print_success "Bootstrap script completed successfully"
    print_status "Next steps:"
    echo "  1. Open new terminal (log out and log back in)."
    echo "  2. Run 'p10k configure' to set up Powerlevel10k"
    if [[ "$OS" == "wsl-ubuntu" ]]; then
        echo "  3. (Optional) Install a Nerd Font in Windows Terminal for better icon support"
        echo "     - Download from https://www.nerdfonts.com/"
        echo "     - Set in Windows Terminal: Settings > Profiles > Ubuntu > Appearance > Font face"
    else
        echo "  3. Consider installing a Nerd Font for better icon support"
    fi
    echo ""
    echo "Installed tools:"
    echo "  - Oh My Zsh"
    echo "  - Powerlevel10k"
    echo "  - fzf"
    echo "  - z"
    echo "  - rg"
    echo "  - bat"
    echo "  - eza"
    echo "  - uv"
    echo "  - jq"
    echo "  - zsh-autosuggestions"
    echo "  - zsh-syntax-highlighting"
}

# Was reading https://medium.com/@Aenon/bash-location-of-current-script-76db7fd2e388 and stumbled upon BASH_SOURCE
# Similar to if __name__ == "__main__": in python, tho I don't intend on this being sourced
# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi
