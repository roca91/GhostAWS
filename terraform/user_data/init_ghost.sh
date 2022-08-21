#!/bin/bash -xe

# Send the output to the console logs and at /var/log/user-data.log
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

    # Update packages
    apt-get update && sudo apt-get upgrade -y

    # Install Nginx ec2-instance-connect
    apt-get install -y nginx ec2-instance-connect

    # Increase the server_names_hash_bucket_size to 128 in order to accept long domain names
    echo "server_names_hash_bucket_size 128;" | sudo tee /etc/nginx/conf.d/server_names_hash_bucket_size.conf

    # Add the NodeSource APT repository for Node 16
    curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash

    # Install Node.js && npm
    apt-get install -y nodejs
    npm install npm@latest -g

    # Install Ghost-CLI
    npm install ghost-cli@latest -g

    # Give permission to ubuntu user, create directory 
    chown -R ubuntu:ubuntu /var/www/
    sudo -u ubuntu mkdir -p /var/www/droneShuttlesLtd && cd /var/www/droneShuttlesLtd

    # Install Ghost, cannot be run via root (user data default)
    sudo -u ubuntu ghost install \
        --url "${url}" \
        --admin-url "${admin_url}" \
        --db "mysql" \
        --dbhost "${endpoint}" \
        --dbuser "${username}" \
        --dbpass "${password}" \
        --dbname "${database}" \
        --process systemd \
        --no-setup-ssl \
        --no-prompt 
    
    # Change Ghost config to accept connection via HTTP and restart the Ghost instance
    sudo sed -i 's/https/http/g' /var/www/droneShuttlesLtd/config.production.json 
    sudo -u ubuntu ghost restart
    