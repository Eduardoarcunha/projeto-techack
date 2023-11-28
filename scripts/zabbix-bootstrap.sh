#!/bin/bash

sudo apt-get update

sudo apt-get install apache2 -y

sudo apt-get install mysql-server -y

sudo apt-get install php php-pear php-cgi php-common libapache2-mod-php php-mbstring php-net-socket php-gd php-xml-util php-mysql php-bcmath -y

wget https://repo.zabbix.com/zabbix/6.2/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.2-2+ubuntu22.04_all.deb
sudo dpkg -i zabbix-release_6.2-2+ubuntu22.04_all.deb
sudo apt-get update
sudo apt-get install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent -y

sudo mysql -e "create database zabbix character set utf8mb4 collate utf8mb4_bin;"
sudo mysql -e "create user zabbix@localhost identified by 'password';"
sudo mysql -e "grant all privileges on zabbix.* to zabbix@localhost;"
sudo mysql -e "set global log_bin_trust_function_creators = 1;"

# Import initial schema and data for Zabbix
sudo zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -uzabbix -p'password' zabbix

# Reset MySQL settings
sudo mysql -e "set global log_bin_trust_function_creators = 0;"

# Update Zabbix configuration
sudo sed -i 's/# DBPassword=/DBPassword=password/' /etc/zabbix/zabbix_server.conf

# Restart and enable services
sudo systemctl restart zabbix-server zabbix-agent apache2
sudo systemctl enable zabbix-server zabbix-agent apache2

# Install language pack
sudo apt-get install language-pack-en -y
