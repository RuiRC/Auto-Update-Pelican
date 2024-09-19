#!/bin/bash

# Colors for echo
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to print success message
print_success() {
    echo -e "${GREEN}$1${NC}"
}

# Function to print error message
print_error() {
    echo -e "${RED}$1${NC}"
}

# Function to update itself
self_update() {
    echo "Checking for script updates..."
    if curl -L -o "$0" "https://raw.githubusercontent.com/RuiRC/Update-Pelican/main/updater.sh"; then
        print_success "Updater script updated successfully."
        exec bash "$0" # Restart the updater script
    else
        print_error "Failed to update the updater script."
        exit 1
    fi
}

# Self-update the updater script
self_update

# Pull the update commands from the repository
echo "Pulling update commands..."
if curl -L -o /tmp/update.sh "https://raw.githubusercontent.com/RuiRC/Update-Pelican/main/update.sh"; then
    print_success "Update commands pulled successfully."
    chmod +x /tmp/update.sh
    # Run the update commands
    /tmp/update.sh
else
    print_error "Failed to pull update commands."
    exit 1
fi
