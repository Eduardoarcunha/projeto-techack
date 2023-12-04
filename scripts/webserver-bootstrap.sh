#!/bin/bash

echo "SERVER_IP = ${server_ip}"
export SERVER_IP=${server_ip}

echo "ZABBIX_IP = ${zabbix_ip}"
export ZABBIX_IP=${zabbix_ip}


sudo yum update

sudo yum install git -y


cd /home/ec2-user
git clone https://github.com/Eduardoarcunha/sql-da-gama-publico.git

cd sql-da-gama-publico


sudo yum install python3 pip -y
sudo pip install -r requirements.txt


sudo tee .env > /dev/null <<EOF
username="root"
password="banana"
server_ip="${server_ip}"
EOF

sudo bash -c 'cat > /etc/systemd/system/fastapi.service << EOF
[Unit]
Description=FastAPI service
After=network.target

[Service]
User=ec2-user
WorkingDirectory=/home/ec2-user/sql-da-gama-publico
ExecStart=/usr/local/bin/uvicorn main:app --host 0.0.0.0 --port 8000
Restart=always

[Install]
WantedBy=multi-user.target
EOF'

sudo systemctl daemon-reload
sudo systemctl enable fastapi
sudo systemctl start fastapi

sudo yum update -y
sudo yum upgrade -y

sudo rpm -Uvh https://repo.zabbix.com/zabbix/6.2/rhel/9/x86_64/zabbix-agent-6.2.0-1.el9.x86_64.rpm
sudo yum clean all
sudo yum install zabbix-agent --skip-broken -y

sudo sed -i "s/^Server=.*/Server=${zabbix_ip}/" /etc/zabbix/zabbix_agentd.conf
sudo sed -i "s/^ServerActive=.*/ServerActive=${zabbix_ip}/" /etc/zabbix/zabbix_agentd.conf
sudo sed -i "s/^Hostname=.*/Hostname=app-server/" /etc/zabbix/zabbix_agentd.conf

sudo systemctl enable zabbix-agent
sudo systemctl start zabbix-agent
sudo systemctl status zabbix-agent