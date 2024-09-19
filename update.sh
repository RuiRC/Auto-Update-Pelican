#!/bin/bash

# Colors for echo
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'  # Yellow for prompts
NC='\033[0m' # No Color

# Function to print success message
print_success() {
    echo -e "${GREEN}$1${NC}"
}

# Function to print error message
print_error() {
    echo -e "${RED}$1${NC}"
}

# Update and upgrade the system
echo "Updating and upgrading the system..."
if sudo apt update -y && sudo apt upgrade -y; then
    print_success "System update and upgrade completed successfully."
else
    print_error "System update and upgrade failed."
    exit 1
fi

# Function to update Pelican Panel
update_panel() {
    echo "Updating Pelican Panel..."
    
    # Enter maintenance mode
    cd /var/www/pelican || exit
    php artisan down
    
    # Download and extract the latest panel update
    if curl -L https://github.com/pelican-dev/panel/releases/latest/download/panel.tar.gz | sudo tar -xzv; then
        print_success "Downloaded and extracted the latest panel update."
    else
        print_error "Failed to download and extract the latest panel update."
        exit 1
    fi
    
    # Set correct permissions
    if chmod -R 755 storage/* bootstrap/cache; then
        print_success "Set correct permissions."
    else
        print_error "Failed to set correct permissions."
        exit 1
    fi
    
    # Update dependencies
    if composer install --no-dev --optimize-autoloader; then
        print_success "Updated dependencies."
    else
        print_error "Failed to update dependencies."
        exit 1
    fi
    
    # Clear compiled template cache
    if php artisan view:clear && php artisan config:clear; then
        print_success "Cleared compiled template cache."
    else
        print_error "Failed to clear compiled template cache."
        exit 1
    fi
    
    # Update database schema
    if php artisan migrate --seed --force; then
        print_success "Updated database schema."
    else
        print_error "Failed to update database schema."
        exit 1
    fi
    
    # Set proper ownership of the files
    if chown -R www-data:www-data /var/www/pelican; then
        print_success "Set proper ownership of the files."
    else
        print_error "Failed to set proper ownership of the files."
        exit 1
    fi
    
    # Restart queue workers
    if php artisan queue:restart; then
        print_success "Restarted queue workers."
    else
        print_error "Failed to restart queue workers."
        exit 1
    fi
    
    # Exit maintenance mode
    if php artisan up; then
        print_success "Exited maintenance mode."
    else
        print_error "Failed to exit maintenance mode."
        exit 1
    fi
    
    print_success "Pelican Panel update completed."
}

# Function to update Pelican Wings
update_wings() {
    echo "Updating Pelican Wings..."
    
    # Stop Wings service
    if systemctl stop wings; then
        print_success "Stopped Wings service."
    else
        print_error "Failed to stop Wings service."
        exit 1
    fi
    
    # Download the latest Wings binary
    if curl -L -o /usr/local/bin/wings "https://github.com/pelican-dev/wings/releases/latest/download/wings_linux_$([[ "$(uname -m)" == "x86_64" ]] && echo "amd64" || echo "arm64")"; then
        print_success "Downloaded the latest Wings binary."
    else
        print_error "Failed to download the latest Wings binary."
        exit 1
    fi
    
    # Set executable permissions
    if chmod +x /usr/local/bin/wings; then
        print_success "Set executable permissions."
    else
        print_error "Failed to set executable permissions."
        exit 1
    fi
    
    # Start Wings service
    if systemctl start wings; then
        print_success "Started Wings service."
    else
        print_error "Failed to start Wings service."
        exit 1
    fi
    
    print_success "Pelican Wings update completed."
}

# Main update function
update() {
    # Ask if the user wants to update the Panel
    printf "${YELLOW}Would you like to update the Pelican Panel? (yes/no): ${NC}"
    read -r panel_response
    if [[ "$panel_response" == "yes" ]]; then
        update_panel
    else
        echo "Skipped updating the Pelican Panel."
    fi

    # Ask if the user wants to update the Wings
    printf "${YELLOW}Would you like to update the Pelican Wings? (yes/no): ${NC}"
    read -r wings_response
    if [[ "$wings_response" == "yes" ]]; then
        update_wings
    else
        echo "Skipped updating the Pelican Wings."
    fi
}

# Run the update function
update
