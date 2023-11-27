#!/bin/bash

# Update the system's package index
sudo dnf update -y

# Install MariaDB server
sudo dnf install mariadb105-server -y

# Start the MariaDB service
sudo systemctl start mariadb

# Enable MariaDB to start on boot
sudo systemctl enable mariadb

# Secure the installation and set the root password
sudo mysql_secure_installation <<EOF

n
Y
banana
banana
n
n
n
Y
EOF

echo ${bastion_ip}
MYIP=${bastion_ip}
echo "Granting privileges for IP: $MYIP"

mysql -u root -p'banana' <<EOF
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'banana';
FLUSH PRIVILEGES;
EOF

