#!/bin/bash

# Remove existing update.sh if it exists
if [ -f update.sh ]; then
    echo "Removing existing update.sh..."
    rm update.sh
fi

# Pull the update commands directly
echo "Downloading update commands..."
if curl -L -o update.sh "https://raw.githubusercontent.com/RuiRC/Update-Pelican/main/update.sh"; then
    echo "Update commands downloaded successfully."
    
    # Make sure the script is executable
    chmod +x update.sh
    
    # Run the update commands
    if ./update.sh; then
        echo "Update commands executed successfully."
    else
        echo "Failed to execute update commands."
        exit 1
    fi
else
    echo "Failed to download update commands."
    exit 1
fi
