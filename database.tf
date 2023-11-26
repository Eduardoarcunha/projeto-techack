resource "aws_security_group" "my_sql_sg" {
  name        = "${var.project}-mysql-sg-${var.environment}"
  description = "Security group for MySQL"
  vpc_id      = aws_vpc.webserver-vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.ec2-bastion-sg.id]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [aws_security_group.ec2-bastion-sg.id]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "my_sql_instance" {
  # depends_on = [ aws_instance.ec2-bastion-host ]

  ami = "ami-05c13eab67c5d8861"
  instance_type = "t2.micro"
  key_name = aws_key_pair.ec2-bastion-host-key-pair.key_name

  subnet_id                   = aws_subnet.vpc-private-subnet-1.id
  vpc_security_group_ids      = [aws_security_group.my_sql_sg.id]
  associate_public_ip_address = false
  
  tags = {
    Name = "${var.project}-mysql-${var.environment}"
  }

  # user_data = file(var.mysql-bootstrap-script-path)
  user_data = base64encode(
    templatefile(
      var.mysql-bootstrap-script-path,
      {
        bastion_ip = aws_instance.ec2-bastion-host.private_ip
      }
    )
  )
}