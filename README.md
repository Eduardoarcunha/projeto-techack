# Projeto Techack

Alunos: Eduardo Araujo e Paulo Falcão 

O projeto consiste em uma infraestrutura como código utilizando terraform. A infraestrutura consiste em 4 instâncias ec2, um servidor de aplicação, um servidor para banco de dados, um servidor Zabbyx para monitoramento e um servidor bastion com MFA como porta de entrada para as outras instâncias.

[Video explicativo do projeto](https://www.youtube.com/watch?v=dNbQwpLEZXk)

Para rodar o projeto:

`terraform apply`


Acesso ao jumpbox:


```
ssh -i ec2-bastion-key-pair.pem ec2-user@<public-ipv4-of-eip>
```


