resource "aws_security_group" "app_sg" {
  name        = "${var.project}-app-sg-${var.environment}"
  description = "Security group for App"
  vpc_id      = aws_vpc.webserver-vpc.id

  ingress {
    from_port = 8000
    to_port = 8000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [aws_security_group.ec2-bastion-sg.id]
  }

  ingress {
    from_port = 10050
    to_port = 10050
    protocol = "tcp"
    security_groups = [aws_security_group.zabbix-server.id]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "app_instance" {
  depends_on = [ aws_instance.my_sql_instance, aws_instance.instance-zabbix-server]

  ami = "ami-05c13eab67c5d8861"
  instance_type = "t2.micro"
  key_name = aws_key_pair.ec2-bastion-host-key-pair.key_name

  subnet_id                   = aws_subnet.vpc-public-subnet-1.id
  vpc_security_group_ids      = [aws_security_group.app_sg.id]
  associate_public_ip_address = true
  
  tags = {
    Name = "${var.project}-app-${var.environment}"
  }

  user_data = data.template_file.webserver_script.rendered
}

data "template_file" "webserver_script" {
  template = file("${var.webserver-bootstrap-script-path}")

  vars = {
    server_ip = aws_instance.my_sql_instance.private_ip,
    zabbix_ip = aws_instance.instance-zabbix-server.private_ip
  }
}

output "app_instance-private-ip" {
  value = aws_instance.app_instance.private_ip
}