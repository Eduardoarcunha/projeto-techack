#!/bin/bash

echo "ZABBIX_IP = ${zabbix_ip}"
export ZABBIX_IP=${zabbix_ip}

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

mysql -u root -p'banana' <<EOF
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'banana';
FLUSH PRIVILEGES;
CREATE DATABASE rottentomatoes;
EOF

sudo yum update -y
sudo yum upgrade -y

sudo rpm -Uvh https://repo.zabbix.com/zabbix/6.2/rhel/9/x86_64/zabbix-agent-6.2.0-1.el9.x86_64.rpm
sudo yum clean all
sudo yum install zabbix-agent --skip-broken -y

sudo sed -i "s/^Server=.*/Server=${zabbix_ip}/" /etc/zabbix/zabbix_agentd.conf
sudo sed -i "s/^ServerActive=.*/ServerActive=${zabbix_ip}/" /etc/zabbix/zabbix_agentd.conf
sudo sed -i "s/^Hostname=.*/Hostname=mysql-server/" /etc/zabbix/zabbix_agentd.conf

sudo systemctl enable zabbix-agent
sudo systemctl start zabbix-agent
sudo systemctl status zabbix-agent
