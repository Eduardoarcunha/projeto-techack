# Create Security Group - ZabbixServer
resource "aws_security_group" "zabbix-server" {
  vpc_id      = aws_vpc.webserver-vpc.id
  name        = "Zabbix-Server"
  description = "Security Group for the Zabbix Server."

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    security_groups = [aws_security_group.ec2-bastion-sg.id]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 10050
    to_port     = 10051
    cidr_blocks = [var.private-subnet-1-cidr-block]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "Zabbix-Server"
    Application = "Zabbix Server"
  } 
}

# Create EC2 Instance - ZabbixServer
resource "aws_instance" "instance-zabbix-server" {
  instance_type               = "t2.medium"
  ami                         = "ami-0fc5d935ebf8bc3bc"
  vpc_security_group_ids      = [aws_security_group.zabbix-server.id]
  subnet_id                   = aws_subnet.vpc-public-subnet-1.id
  key_name                    = aws_key_pair.ec2-bastion-host-key-pair.key_name
  associate_public_ip_address = true
  user_data                   = file(var.zabbix-bootstrap-script-path)

  tags = {
    Name = "${var.project}-zabbix-server-${var.environment}"
  }
}