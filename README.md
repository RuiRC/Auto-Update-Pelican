# Simple Script to Update Pelican Panel

> **Disclaimer**: This script is based on the docs. Always refer to the official documentation as this script may not be up to date or applicable to your case.

This script assumes that both the Panel and Wings are on the same machine running Debian.

## Instructions

1. Download the script and run the following commands:

    ```bash
    nano update.sh
    ```

2. Make the script executable:

    ```bash
    chmod +x update.sh
    ```

3. Add an alias for the update script:

    ```bash
    echo "alias update='~/update.sh'" >> ~/.bashrc
    ```

4. Apply the changes to your shell:

    ```bash
    source ~/.bashrc
    ```

Now, you can run the update script using the `update` command.
