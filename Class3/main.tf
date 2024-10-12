provider aws {
    region = "us-east-2"
}


resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("~/.ssh/id_rsa.pub")

  tags = local.common_tags
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  #availability_zone = "us-east-2b"
   subnet_id = "subnet-0c43f5449852fc244"
   key_name = aws_key_pair.deployer.key_name
   vpc_security_group_ids = [aws_security_group.allow_tls.id]
   user_data = file("apache.sh")
   count = 3 
  tags = local.common_tags
}

output ec2 {
    value = aws_instance.web[1].public_ip
}