#!/bin/bash

# Ultra simple start script for AI Fitness Planner
# Just runs the backend and frontend with minimal setup

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔═══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                    AI Fitness Planner                         ║${NC}"
echo -e "${BLUE}║                   Simple Start Script                         ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════════╝${NC}"

# Check if we're in the right directory
if [ ! -f "package.json" ] || [ ! -d "server" ]; then
    echo -e "${RED}Error: Please run this script from the project root directory${NC}"
    echo "The directory should contain package.json and a server/ folder"
    exit 1
fi

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo -e "${RED}Error: Node.js not found${NC}"
    echo "To install Node.js on Arch Linux, run:"
    echo -e "${GREEN}sudo pacman -S npm${NC}"
    exit 1
fi

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo -e "${RED}Error: npm not found${NC}"
    echo "To install npm on Arch Linux, run:"
    echo -e "${GREEN}sudo pacman -S npm${NC}"
    exit 1
fi

# Function to install dependencies
install_deps() {
    echo -e "${BLUE}Installing dependencies...${NC}"
    npm install --legacy-peer-deps && cd server && npm install && cd ..
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Dependencies installed successfully${NC}"
    else
        echo -e "${RED}Failed to install dependencies${NC}"
        exit 1
    fi
}

# Check if dependencies need to be installed
if [ "$1" == "--force-install" ] || [ ! -d "node_modules" ] || [ ! -d "server/node_modules" ]; then
    if [ "$1" == "--force-install" ]; then
        echo -e "${BLUE}Forcing reinstall of dependencies...${NC}"
        rm -rf node_modules server/node_modules
    fi
    install_deps
fi

# Create environment file if it doesn't exist
if [ ! -f "server/.env" ]; then
    echo "Creating server environment file..."
    cat > server/.env << EOF
PORT=3002
NODE_ENV=development
JWT_SECRET=dev-secret-key
CLIENT_URL=http://localhost:5173
EOF
    echo -e "${GREEN}Environment file created at server/.env${NC}"
fi

echo -e "${BLUE}Starting backend server...${NC}"
echo -e "${GREEN}Backend will be available at: http://localhost:3002${NC}"
cd server && npm start &
SERVER_PID=$!
cd ..

echo -e "${BLUE}Starting frontend...${NC}"
echo -e "${GREEN}Frontend will be available at: http://localhost:5173${NC}"
echo -e "${RED}Press Ctrl+C to stop both server and frontend${NC}"
npm run dev

# When npm run dev ends, kill the server process
kill $SERVER_PID 2>/dev/null
