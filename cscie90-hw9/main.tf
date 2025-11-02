provider "aws" {
  region = terraform.workspace == "default" ? "us-east-1" : "us-east-2"
}

#Get Linux AMI ID using SSM Parameter endpoint in us-east-1
data "aws_ssm_parameter" "linuxAmi" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

#Create and bootstrap EC2 in us-east-1
resource "aws_instance" "ec2-vm" {
  ami                         = data.aws_ssm_parameter.linuxAmi.value
  instance_type               = "t2.nano"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.sg.id]
  subnet_id                   = aws_subnet.public_subnet.id
  key_name                    = "cscie90-2025-key-pair"
  tags = {
    Name = "${terraform.workspace}-ec2",
    Group = "cscie90"
  }
}

# Create EC2 in private subnet
resource "aws_instance" "private-ec2-vm" {
  ami                         = data.aws_ssm_parameter.linuxAmi.value
  instance_type               = "t2.nano"
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.sg.id]
  subnet_id                   = aws_subnet.private_subnet.id
  key_name                    = "cscie90-2025-key-pair"
  tags = {
    Name = "${terraform.workspace}-private-ec2",
    Group = "cscie90"
  }
}

