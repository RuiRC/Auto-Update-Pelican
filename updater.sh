#!/bin/bash

# Define colors for messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Define URLs
REPO_UPDATER_URL="https://raw.githubusercontent.com/RuiRC/Auto-Update-Pelican/main/updater.sh"
UPDATE_SCRIPT_URL="https://raw.githubusercontent.com/RuiRC/Auto-Update-Pelican/main/update.sh"

# Define paths
TEMP_UPDATER_FILE="/tmp/updater_remote.sh"
TEMP_UPDATE_FILE="/tmp/update.sh"

# Check for updates to this script
echo "Checking for updates to the updater script..."
if curl -s -o "$TEMP_UPDATER_FILE" "$REPO_UPDATER_URL"; then
    # Compare the local updater.sh with the remote version
    if ! diff -q updater.sh "$TEMP_UPDATER_FILE" > /dev/null; then
        echo -e "${RED}The updater script has been modified. Would you like to download the latest version automatically? ${YELLOW}(yes/no)${NC}"
        read -r response

        if [[ "$response" == "yes" ]]; then
            echo "Downloading the latest updater script..."
            mv updater.sh updater.sh.bak  # Backup the old version
            if curl -L -o updater.sh "$REPO_UPDATER_URL"; then
                echo -e "${GREEN}Updater script downloaded successfully.${NC}"
                chmod +x updater.sh
            else
                echo "Failed to download the updater script."
                rm "$TEMP_UPDATER_FILE"  # Clean up the temporary file
                exit 1
            fi
        else
            echo -e "${RED}Please download the latest version manually at: https://github.com/RuiRC/Auto-Update-Pelican${NC}"
            rm "$TEMP_UPDATER_FILE"  # Clean up the temporary file
            exit 1
        fi
    else
        echo -e "${GREEN}No new updates available for the updater script.${NC}"
    fi
else
    echo "Failed to download the updater script from the repository."
    exit 1
fi

# Clean up the downloaded remote updater file
rm "$TEMP_UPDATER_FILE"

# Ask if the user wants to update automatically
echo -e "${YELLOW}Do you want to perform updates automatically? (yes/no)${NC}"
read -r auto_update_response

if [[ "$auto_update_response" == "yes" ]]; then
    echo "Automatic update mode enabled."

    # Download the update script
    echo "Downloading update commands..."
    if curl -L -o "$TEMP_UPDATE_FILE" "$UPDATE_SCRIPT_URL"; then
        echo "Update commands downloaded successfully."

        # Make sure the script is executable
        chmod +x "$TEMP_UPDATE_FILE"

        # Run the update commands
        echo "Executing update commands..."
        if sudo bash "$TEMP_UPDATE_FILE" --auto; then
            echo "Update commands executed successfully."
        else
            echo "Failed to execute update commands."
            rm "$TEMP_UPDATE_FILE"  # Clean up the temporary file
            exit 1
        fi

        # Clean up by removing the temporary file
        echo "Cleaning up..."
        rm "$TEMP_UPDATE_FILE"

        # Prompt user for reboot
        echo -e "${YELLOW}Would you like to reboot the machine now? (yes/no)${NC}"
        read -r reboot_response

        if [[ "$reboot_response" == "yes" ]]; then
            echo "Rebooting the machine..."
            sudo reboot
        else
            echo "Reboot skipped. Please reboot manually when convenient."
        fi
    else
        echo "Failed to download update commands."
        exit 1
    fi
else
    # Ask about updating the panel
    echo -e "${YELLOW}Do you want to continue the update? (yes/no)${NC}"
    read -r update_panel_response

    if [[ "$update_panel_response" == "yes" ]]; then
        # Remove existing update.sh if it exists
        if [ -f update.sh ]; then
            echo "Removing existing update.sh..."
            rm update.sh
        fi

        # Pull the update commands directly into a temporary file
        echo "Downloading update commands..."
        if curl -L -o update.sh "$UPDATE_SCRIPT_URL"; then
            echo "Update commands downloaded successfully."

            # Make sure the temporary script is executable
            chmod +x update.sh

            # Run the update commands
            echo "Executing update commands..."
            if sudo bash update.sh; then
                echo "Update commands executed successfully."
            else
                echo "Failed to execute update commands."
                exit 1
            fi

            # Clean up by removing the temporary file
            echo "Cleaning up..."
            rm update.sh

            # Prompt user for reboot
            echo -e "${YELLOW}Would you like to reboot the machine now? (yes/no)${NC}"
            read -r reboot_response

            if [[ "$reboot_response" == "yes" ]]; then
                echo "Rebooting the machine..."
                sudo reboot
            else
                echo "Reboot skipped. Please reboot manually when convenient."
            fi
        else
            echo "Failed to download update commands."
            exit 1
        fi
    else
        echo "Update was skipped."
    fi
fi
