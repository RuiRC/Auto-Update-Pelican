# Simple Script to Update Pelican Panel

> **Disclaimer**: This script is based on the [official documentation](https://pelican.dev/docs/). Always refer to the docs as this script may not be up to date or applicable to your case.

This script assumes that both the Panel and Wings are on the same machine running Debian.

## Instructions

1. Download the updater script using `curl`:

    ```bash
    curl -L -o updater.sh https://raw.githubusercontent.com/RuiRC/Update-Pelican/main/updater.sh
    ```

2. Make the updater script executable:

    ```bash
    chmod +x updater.sh
    ```

3. Run the updater script to pull the update commands and execute them:

    ```bash
    ./updater.sh
    ```

4. (Optional) Add an alias for the update script:

    ```bash
    echo "alias update='~/update.sh'" >> ~/.bashrc
    ```

5. Apply the changes to your shell:

    ```bash
    source ~/.bashrc
    ```

Now, you can run the update script using the `update` command.
