locals {
  key = "mykey.pem"
}
provider "aws" {
 region = "ap-south-1"
}
resource "aws_instance" "ec2-server" {
  ami           = "ami-02eb7a4783e7e9317"
  instance_type = "t2.micro"
  key_name = "mykey"
  vpc_security_group_ids= ["sg-00fd2fb52aa7dd027"]
  connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = file(local.key)
    host  =  aws_instance.ec2-server.public_ip
  }
  tags = {
    Name = "terraform"
  }
  }
  provisioner "local-exec" {
    command = "ansible-playbook -i ${aws_instance.ec2-server.private_ip}, --private-key ${local.key} bank-playbook.yml"
  }
}
