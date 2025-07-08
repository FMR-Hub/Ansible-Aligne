#!/usr/bin/env bash

# This script installs AnsibleAligne

# Tool: AnsibleAligne Playbook Creation Tool

#===Safty checks===#

# check for sudo
if [ "$(id -u)" -ne 0 ]; then
    echo "You need to run this script as root or with sudo."
    exit 1
fi

# Checking for existing installation
if [ -d "/usr/local/bin/AnsibleAligne" ]; then
    echo "AnsibleAligne is already installed."
    read -p "Do you want to reinstall? (y/n): " choice
    if [[ "$choice" != "y" && "$choice" != "Y" ]]; then
        echo "Exiting installation."
        echo "AnsibleAligne is already installed."
        echo "No configuration changes were made."
        exit 0
    else
        echo "Uninstalling AnsibleAligne..."
        rm -rf /usr/local/bin/AnsibleAligne
    fi
fi


#===End of Safty checks===#

# Restarting the installation process
echo "Installing AnsibleAligne..."
echo "This script will install AnsibleAligne in /usr/local/bin/AnsibleAligne"
echo "It will also move the configuration files to /etc/AnsibleAligne"

#==Installation process===#

# Create the /bin already directory if it doesn't exist
echo "Checking for /usr/local/bin/ directory..."
mkdir -p /usr/local/bin/

# Create the installation directory
echo "Creating installation directory..."
mkdir -p /usr/local/bin/AnsibleAligne
echo

for file in ../AnsibleAligne/bin/*; do
    mv "$file" /usr/local/bin/AnsibleAligne/
    chmod +x /usr/local/bin/AnsibleAligne/"$(basename "$file")"
    echo "Moved $(basename "$file") to /usr/local/bin/AnsibleAligne/"
done

# move config files to /etc/AnsibleAligne
sudo mkdir -p /etc/AnsibleAligne

for file in ../AnsibleAligne/config/*; do
    sudo mv "$file" /etc/AnsibleAligne/
    echo "Moved $(basename "$file") to /etc/AnsibleAligne/"
done

#==End of Installation process===#

#==Finalization===#
echo "AnsibleAligne has been successfully installed in /usr/local/bin/AnsibleAligne"
echo "Configuration files have been moved to /etc/AnsibleAligne"
echo "Do you want to configure the AnsibleAligne.conf file now? (y/n): "
read configure_choice
if [[ "$configure_choice" == "y" || "$configure_choice" == "Y" ]]; then
    echo "Perfekt!"
    read -p "Enter the path to your Ansible playbook directory: " playbook_path
    read -p "Enter the path to your Ansible roles directory: " roles_path
    read -p "Enter the path to your Ansible inventory file: " inventory_path


./aa_base_config.sh "$playbook_path" "$roles_path" "$inventory_path"

    echo "AnsibleAligne configuration has been set up."
else
    echo "You can configure AnsibleAligne later by editing /etc/AnsibleAligne/AnsibleAligne.conf"
fi

echo "Installation complete!"




