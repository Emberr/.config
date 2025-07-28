#!/bin/bash

# AI Fitness Planner - Setup and Run Script
# This script will install dependencies and start both server and frontend

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
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
    
    # First, try using the local Node.js if it was previously installed by this script
    if [ -d "$HOME/.local/node/bin" ]; then
        print_status "Found potential local Node.js installation, adding to PATH..."
        export PATH="$HOME/.local/node/bin:$PATH"
    fi
    
    if ! command_exists node; then
        print_warning "Node.js is not installed. Attempting automatic installation..."
        install_nodejs
        # After installation, re-check that everything is working
        if ! command_exists node || ! command_exists npm; then
            print_error "Node.js installation completed but commands not found"
            print_error "Please restart your terminal and run the script again, or install Node.js manually"
            exit 1
        fi
    elif ! command_exists npm; then
        print_warning "Node.js is installed but npm is not found. Attempting automatic installation..."
        install_nodejs
        # After installation, re-check that npm is working
        if ! command_exists npm; then
            print_error "Node.js installation completed but npm command not found"
            print_error "Please restart your terminal and run the script again, or install Node.js manually"
            exit 1
        fi
    fiint colored output
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

# Function to detect architecture and OS
detect_platform() {
    ARCH=$(uname -m)
    OS=$(uname -s)
    
    case $ARCH in
        x86_64)
            ARCH="x64"
            ;;
        arm64|aarch64)
            ARCH="arm64"
            ;;
        *)
            print_error "Unsupported architecture: $ARCH"
            exit 1
            ;;
    esac
    
    case $OS in
        Darwin)
            OS="darwin"
            ;;
        Linux)
            OS="linux"
            ;;
        *)
            print_error "Unsupported operating system: $OS"
            exit 1
            ;;
    esac
}

# Function to install Node.js automatically
install_nodejs() {
    print_status "Node.js not found. Installing Node.js automatically..."
    
    detect_platform
    
    NODE_VERSION="20.10.0"  # LTS version
    NODE_FILENAME="node-v${NODE_VERSION}-${OS}-${ARCH}"
    NODE_URL="https://nodejs.org/dist/v${NODE_VERSION}/${NODE_FILENAME}.tar.xz"
    INSTALL_DIR="$HOME/.local"
    
    # Create install directory
    mkdir -p "$INSTALL_DIR"
    
    # Download Node.js
    print_status "Downloading Node.js v${NODE_VERSION} for ${OS}-${ARCH}..."
    if command_exists curl; then
        if ! curl -L "$NODE_URL" -o "/tmp/${NODE_FILENAME}.tar.xz"; then
            print_error "Failed to download Node.js"
            exit 1
        fi
    elif command_exists wget; then
        if ! wget "$NODE_URL" -O "/tmp/${NODE_FILENAME}.tar.xz"; then
            print_error "Failed to download Node.js"
            exit 1
        fi
    else
        print_error "Neither curl nor wget found. Cannot download Node.js"
        print_error "Please install Node.js manually from https://nodejs.org/"
        exit 1
    fi
    
    # Extract Node.js
    print_status "Extracting Node.js..."
    cd /tmp
    if ! tar -xf "${NODE_FILENAME}.tar.xz"; then
        print_error "Failed to extract Node.js"
        exit 1
    fi
    
    # Remove existing installation if it exists
    if [ -d "$INSTALL_DIR/node" ]; then
        print_status "Removing existing Node.js installation..."
        rm -rf "$INSTALL_DIR/node"
    fi
    
    # Move to install directory
    if ! mv "${NODE_FILENAME}" "$INSTALL_DIR/node"; then
        print_error "Failed to move Node.js to install directory"
        exit 1
    fi
    
    # Add to PATH for current session
    export PATH="$INSTALL_DIR/node/bin:$PATH"
    
    # Add to shell profile for persistence
    SHELL_PROFILE=""
    if [[ $SHELL == *"zsh"* ]]; then
        SHELL_PROFILE="$HOME/.zshrc"
    elif [[ $SHELL == *"bash"* ]]; then
        SHELL_PROFILE="$HOME/.bashrc"
    fi
    
    if [ -n "$SHELL_PROFILE" ]; then
        # Check if PATH export already exists to avoid duplicates
        if ! grep -q "export PATH=\"$INSTALL_DIR/node/bin:\$PATH\"" "$SHELL_PROFILE" 2>/dev/null; then
            echo "export PATH=\"$INSTALL_DIR/node/bin:\$PATH\"" >> "$SHELL_PROFILE"
            print_success "Added Node.js to PATH in $SHELL_PROFILE"
        fi
    fi
    
    # Source profile to update PATH in current session
    if [ -n "$SHELL_PROFILE" ] && [ -f "$SHELL_PROFILE" ]; then
        print_status "Updating PATH in current session..."
        source "$SHELL_PROFILE" 2>/dev/null || . "$SHELL_PROFILE"
    fi
    
    # Verify installation
    print_status "Verifying Node.js installation..."
    print_status "PATH: $PATH"
    if command_exists node && command_exists npm; then
        NODE_VERSION=$(node --version)
        NPM_VERSION=$(npm --version)
        print_success "Node.js $NODE_VERSION installed successfully!"
        print_success "npm $NPM_VERSION is available"
    else
        print_error "Failed to install Node.js or npm not found in PATH"
        print_error "node command available: $(command_exists node && echo 'yes' || echo 'no')"
        print_error "npm command available: $(command_exists npm && echo 'yes' || echo 'no')"
        print_error "PATH: $PATH"
        print_error "Node.js binary location: $INSTALL_DIR/node/bin/node"
        print_error "ls -la $INSTALL_DIR/node/bin/:"
        ls -la "$INSTALL_DIR/node/bin/" || echo "Directory not found"
        
        # Add direct PATH export as a fallback
        print_status "Adding Node.js to PATH as a fallback..."
        export PATH="$INSTALL_DIR/node/bin:$PATH"
        
        if ! command_exists node || ! command_exists npm; then
            print_error "Node.js still not accessible after PATH update"
            exit 1
        else
            print_success "Node.js now accessible via direct PATH export"
        fi
    fi
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check Node.js version
check_node_version() {
    if command_exists node; then
        NODE_VERSION=$(node --version | sed 's/v//')
        MAJOR_VERSION=$(echo $NODE_VERSION | cut -d. -f1)
        if [ "$MAJOR_VERSION" -ge 16 ]; then
            print_success "Node.js version $NODE_VERSION is compatible"
            return 0
        else
            print_warning "Node.js version $NODE_VERSION detected. Version 16+ recommended."
            return 1
        fi
    else
        print_error "Node.js is not installed"
        return 1
    fi
}

# Function to install dependencies
install_dependencies() {
    print_status "Installing dependencies..."
    
    # Verify npm is available
    if ! command_exists npm; then
        print_error "npm command not found. PATH: $PATH"
        print_error "Please ensure Node.js is properly installed"
        exit 1
    fi
    
    # Install frontend dependencies
    print_status "Installing frontend dependencies..."
    print_status "Running: npm install --legacy-peer-deps"
    if npm install --legacy-peer-deps; then
        print_success "Frontend dependencies installed"
    else
        print_error "Failed to install frontend dependencies"
        print_error "npm version: $(npm --version 2>/dev/null || echo 'not found')"
        print_error "node version: $(node --version 2>/dev/null || echo 'not found')"
        print_error "Current directory: $(pwd)"
        print_error "package.json exists: $([ -f package.json ] && echo 'yes' || echo 'no')"
        exit 1
    fi
    
    # Install server dependencies
    print_status "Installing server dependencies..."
    cd server
    print_status "Running: npm install (in server directory)"
    if npm install; then
        print_success "Server dependencies installed"
    else
        print_error "Failed to install server dependencies"
        exit 1
    fi
    cd ..
}

# Function to start the application
start_application() {
    print_status "Starting AI Fitness Planner..."
    print_status "Server will be available at: http://localhost:3002"
    print_status "Frontend will be available at: http://localhost:5173"
    print_status ""
    print_warning "Press Ctrl+C to stop both server and frontend"
    print_status ""
    
    # Start both server and frontend concurrently
    npm run start:all
}

# Function to setup environment file
setup_environment() {
    if [ ! -f "server/.env" ]; then
        print_status "Creating environment file..."
        cp server/.env.example server/.env 2>/dev/null || {
            cat > server/.env << EOF
PORT=3002
NODE_ENV=development
JWT_SECRET=dev-secret-key-change-in-production
CLIENT_URL=http://localhost:5173
EOF
        }
        print_success "Environment file created at server/.env"
        print_warning "Remember to change JWT_SECRET in production!"
    fi
}

# Main execution
main() {
    echo -e "${BLUE}"
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║                    AI Fitness Planner                         ║"
    echo "║                   Setup & Run Script                          ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    # Check if we're in the right directory
    if [ ! -f "package.json" ] || [ ! -d "server" ]; then
        print_error "Please run this script from the AI Fitness Planner root directory"
        print_error "The directory should contain package.json and a server/ folder"
        exit 1
    fi
    
    # Check prerequisites
    print_status "Checking prerequisites..."
    
    if ! command_exists node; then
        print_warning "Node.js is not installed. Attempting automatic installation..."
        install_nodejs
        # After installation, re-check that everything is working
        if ! command_exists node || ! command_exists npm; then
            print_error "Node.js installation completed but commands not found"
            print_error "Please restart your terminal and run the script again, or install Node.js manually"
            exit 1
        fi
    fi
    
    if ! command_exists npm; then
        print_error "npm is not installed!"
        print_error "npm usually comes with Node.js installation"
        print_error "Please check your Node.js installation"
        exit 1
    fi
    
    check_node_version
    
    # Setup environment
    setup_environment
    
    # Check if dependencies are already installed
    if [ ! -d "node_modules" ] || [ ! -d "server/node_modules" ]; then
        install_dependencies
    else
        print_status "Dependencies already installed, skipping installation"
        print_status "Use --force-install to reinstall dependencies"
    fi
    
    # Start the application
    start_application
}

# Handle command line arguments
case "${1:-}" in
    --install-only)
        print_status "Installing dependencies only..."
        install_dependencies
        print_success "Dependencies installed successfully!"
        print_status "Run './start.sh' to start the application"
        ;;
    --force-install)
        print_status "Force reinstalling dependencies..."
        rm -rf node_modules server/node_modules
        install_dependencies
        start_application
        ;;
    --help|-h)
        echo "AI Fitness Planner Setup & Run Script"
        echo ""
        echo "Usage: $0 [OPTIONS]"
        echo ""
        echo "Options:"
        echo "  (no options)      Install dependencies (if needed) and start the application"
        echo "  --install-only    Only install dependencies, don't start the application"
        echo "  --force-install   Force reinstall all dependencies and start"
        echo "  --help, -h        Show this help message"
        echo ""
        echo "Prerequisites:"
        echo "  - Node.js 16+ (recommended: 18+)"
        echo "  - npm"
        echo ""
        echo "The application will be available at:"
        echo "  Frontend: http://localhost:5173"
        echo "  Backend:  http://localhost:3002"
        ;;
    *)
        main
        ;;
esac
