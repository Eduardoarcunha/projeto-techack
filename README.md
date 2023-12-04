# projeto-techack

Acesso ao jumpbox:

```
ssh -i ec2-bastion-key-pair.pem ec2-user@<public-ipv4-of-eip>

```

```
sudo yum install google-authenticator -y

```

See init logs:

`cat /var/log/cloud-init-output.log`

#!/bin/bash

sudo yum update -y
sudo yum upgrade -y

sudo rpm -Uvh https://repo.zabbix.com/zabbix/6.2/rhel/9/x86_64/zabbix-agent-6.2.0-1.el9.x86_64.rpm
sudo yum clean all

sudo yum install zabbix-agent --skip-broken -y

# Here in this, I will send all the vars through terraform to script
sudo vim /etc/zabbix/zabbix_agentd.conf
    Server=<Zabbix_Server_IP>
    ServerActive=<Zabbix_Server_IP>
    Hostname=<Hostname_Of_Amazon_Linux_Client>

sudo systemctl enable zabbix-agent
sudo systemctl start zabbix-agent
sudo systemctl status zabbix-agent
