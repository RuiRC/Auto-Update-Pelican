#!/bin/bash

# Temporary file for update commands
TEMP_UPDATE_FILE="/tmp/update.sh"

# Pull the update commands directly into a temporary file from the new repo
echo "Downloading update commands..."
if curl -L -o "$TEMP_UPDATE_FILE" "https://raw.githubusercontent.com/RuiRC/Auto-Update-Pelican/main/update.sh"; then
    echo "Update commands downloaded successfully."
    
    # Make sure the temporary script is executable
    chmod +x "$TEMP_UPDATE_FILE"
    
    # Run the update commands
    echo "Executing update commands..."
    if bash "$TEMP_UPDATE_FILE"; then
        echo "Update commands executed successfully."
    else
        echo "Failed to execute update commands."
        exit 1
    fi
    
    # Clean up by removing the temporary file
    echo "Cleaning up..."
    rm "$TEMP_UPDATE_FILE"
else
    echo "Failed to download update commands."
    exit 1
fi
