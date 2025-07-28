#!/bin/bash

# Simple start script for AI Fitness Planner
# Just runs the backend and frontend with minimal setup

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Starting AI Fitness Planner...${NC}"

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

# Run the application in a tmux session to manage both processes
if ! command -v tmux &> /dev/null; then
    # Run without tmux (will only show output from the last command)
    echo -e "${BLUE}Starting backend server...${NC}"
    echo "Backend will be available at: http://localhost:3002"
    # Make sure we're in the project root directory
    cd "$(dirname "$0")"
    cd server && npm start &
    SERVER_PID=$!
    cd "$(dirname "$0")"
    
    echo -e "${BLUE}Starting frontend...${NC}"
    echo "Frontend will be available at: http://localhost:5173"
    npm run dev
    
    # Kill the backend when frontend is stopped
    kill $SERVER_PID 2>/dev/null
else
    # Use tmux if available for better process management
    echo -e "${BLUE}Starting backend and frontend in tmux session...${NC}"
    ROOT_DIR="$(dirname "$(readlink -f "$0")")"
    tmux new-session -d -s fitness-app "cd \"$ROOT_DIR/server\" && npm start"
    tmux split-window -h "cd \"$ROOT_DIR\" && npm run dev"
    tmux -2 attach-session -d -t fitness-app
    
    echo "To detach from tmux: press Ctrl+B then D"
    echo "To kill all processes: exit both panes or run 'tmux kill-session -t fitness-app'"
fi
