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
