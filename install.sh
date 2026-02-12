#!/usr/bin/env bash
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
log_info() {
  echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
  echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warn() {
  echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
  echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running on Ubuntu/Debian
check_os() {
  if [[ ! -f /etc/os-release ]]; then
    log_warn "Cannot detect OS. This script is designed for Ubuntu/Debian."
    read -p "Continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      exit 1
    fi
  else
    source /etc/os-release
    if [[ "$ID" != "ubuntu" && "$ID" != "debian" ]]; then
      log_warn "Detected OS: $NAME"
      log_warn "This script is optimized for Ubuntu/Debian."
      read -p "Continue anyway? (y/N) " -n 1 -r
      echo
      if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
      fi
    fi
  fi
}

# Install system dependencies
install_dependencies() {
  log_info "Updating package lists..."
  sudo apt-get update

  log_info "Installing dependencies..."
  sudo apt-get install -y \
    git \
    curl \
    wget \
    unzip \
    tar \
    gzip \
    build-essential \
    software-properties-common \
    ripgrep \
    fd-find \
    luarocks \
    python3 \
    python3-pip \
    python3-venv \
    nodejs \
    npm

  # Create symlink for fd (Ubuntu names it fdfind)
  if command -v fdfind &> /dev/null && ! command -v fd &> /dev/null; then
    log_info "Creating fd symlink..."
    sudo ln -sf "$(which fdfind)" /usr/local/bin/fd
  fi

  log_success "Dependencies installed"
}

# Install Neovim
install_neovim() {
  if command -v nvim &> /dev/null; then
    log_info "Neovim already installed: $(nvim --version | head -n 1)"
    return 0
  fi

  log_info "Installing Neovim..."

  # Try to install from official PPA for latest stable version
  if [[ -f /etc/os-release ]]; then
    source /etc/os-release
    if [[ "$ID" == "ubuntu" ]]; then
      log_info "Adding Neovim PPA..."
      sudo add-apt-repository -y ppa:neovim-ppa/stable
      sudo apt-get update
      sudo apt-get install -y neovim
    else
      # For Debian or other, use AppImage
      install_neovim_appimage
    fi
  else
    install_neovim_appimage
  fi

  log_success "Neovim installed: $(nvim --version | head -n 1)"
}

# Install Neovim via AppImage (fallback)
install_neovim_appimage() {
  log_info "Installing Neovim via AppImage..."
  
  NVIM_VERSION="stable"
  APPIMAGE_URL="https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim.appimage"
  
  cd /tmp
  wget -q --show-progress "$APPIMAGE_URL" -O nvim.appimage
  chmod +x nvim.appimage
  
  # Extract AppImage if FUSE is not available (common in containers/WSL)
  if ! ./nvim.appimage --version &> /dev/null; then
    log_info "Extracting AppImage (FUSE not available)..."
    ./nvim.appimage --appimage-extract &> /dev/null
    sudo mv squashfs-root /opt/nvim
    sudo ln -sf /opt/nvim/AppRun /usr/local/bin/nvim
  else
    sudo mv nvim.appimage /usr/local/bin/nvim
  fi
  
  cd - > /dev/null
}

# Setup dotfiles
setup_dotfiles() {
  log_info "Setting up dotfiles..."

  DOTFILES_DIR="${HOME}/dotfiles"
  
  # Check if we're already in the dotfiles repo
  if [[ -d "$(dirname "$0")/.git" ]] && [[ -f "$(dirname "$0")/nvim/init.lua" ]]; then
    DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
    log_info "Using current directory as dotfiles: $DOTFILES_DIR"
  elif [[ ! -d "$DOTFILES_DIR" ]]; then
    log_info "Cloning dotfiles repository..."
    git clone https://github.com/lbrevoort/dotfiles.git "$DOTFILES_DIR" || {
      log_warn "Could not clone repository. You may need to clone it manually."
      log_info "Run: git clone <your-dotfiles-repo> ~/dotfiles"
    }
  else
    log_info "Dotfiles directory already exists: $DOTFILES_DIR"
  fi

  # Create .config directory
  mkdir -p "${HOME}/.config"

  # Backup existing nvim config
  if [[ -d "${HOME}/.config/nvim" ]] && [[ ! -L "${HOME}/.config/nvim" ]]; then
    BACKUP_DIR="${HOME}/.config/nvim.backup.$(date +%Y%m%d_%H%M%S)"
    log_warn "Backing up existing nvim config to $BACKUP_DIR"
    mv "${HOME}/.config/nvim" "$BACKUP_DIR"
  fi

  # Create symlink
  if [[ -L "${HOME}/.config/nvim" ]]; then
    log_info "Removing existing nvim symlink..."
    rm "${HOME}/.config/nvim"
  fi

  ln -sf "${DOTFILES_DIR}/nvim" "${HOME}/.config/nvim"
  log_success "Dotfiles linked: ${DOTFILES_DIR}/nvim -> ${HOME}/.config/nvim"
}

# Install additional tools for LazyVim
install_lazyvim_tools() {
  log_info "Installing tools for LazyVim..."

  # Install lazygit
  if ! command -v lazygit &> /dev/null; then
    log_info "Installing lazygit..."
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit /usr/local/bin
    rm lazygit lazygit.tar.gz
    log_success "lazygit installed"
  else
    log_info "lazygit already installed"
  fi

  # Install a Nerd Font (optional but recommended)
  log_info "Note: For best experience, install a Nerd Font manually"
  log_info "Visit: https://www.nerdfonts.com/font-downloads"
}

# Main installation
main() {
  echo "========================================"
  echo "  Dotfiles Installer for Ubuntu"
  echo "========================================"
  echo

  check_os
  install_dependencies
  install_neovim
  setup_dotfiles
  install_lazyvim_tools

  echo
  echo "========================================"
  log_success "Installation complete!"
  echo "========================================"
  echo
  echo "Next steps:"
  echo "  1. Open Neovim: nvim"
  echo "  2. LazyVim will automatically install plugins on first run"
  echo "  3. Run :checkhealth to verify everything is working"
  echo
  echo "Optional: Install a Nerd Font for icons:"
  echo "  https://www.nerdfonts.com/font-downloads"
  echo
}

# Run main function
main "$@"
