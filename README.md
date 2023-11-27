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

sudo yum update

sudo yum install git -y

git clone https://github.com/Eduardoarcunha/sql-da-gama-publico.git

cd sql-da-gama-publico


sudo yum install python3 pip
sudo pip install virtualenv 
virtualenv .env
source .env/bin/activate

pip install -r requirements.txt
uvicorn main:app --host 0.0.0.0 --port 8000 --reload
