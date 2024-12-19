resource "tls_private_key" "Keypair-test" {
  algorithm = "RSA"
  rsa_bits = 2048
}
resource "aws_key_pair" "keypair" {
  key_name = "ConnectKey"
  public_key = tls_private_key.Keypair-test.public_key_openssh
}

#Apache server
resource "aws_instance" "Buntu-Webserver" {
  tags = {
  Name="Buntu-Webserver"
  }

  ami = "ami-0e9085e60087ce171"
  instance_type = "t2.micro"
  key_name = "ConnectKey"

  vpc_security_group_ids = [aws_security_group.SG-SSH-HTTP.id]
  subnet_id = aws_subnet.Sub1.id  
  associate_public_ip_address = "true"

  iam_instance_profile = aws_iam_instance_profile.EC2FullAccessToS3Profile.name
  user_data = data.template_file.Apache.rendered

metadata_options {
  http_endpoint = "enabled"
  http_tokens   = "optional"
  }
}

#MYSQL server
resource "aws_instance" "MySQL-server" {
  tags = {
  Name="MySQL-server"
  }
  ami = "ami-0e9085e60087ce171"
  instance_type = "t2.micro"
  key_name = "ConnectKey"
  
  vpc_security_group_ids = [aws_security_group.SG-SSH-HTTP.id]
  subnet_id = aws_subnet.Sub2.id
  private_ip = "10.0.1.100"
  
  user_data = data.template_file.SQL.rendered

metadata_options {
  http_endpoint = "enabled"
  http_tokens   = "optional"
  }
}

#bucket
resource "aws_s3_bucket" "tm-lode-bucket" {
  tags = {
    name="tm-lode-bucket"
  }
  bucket = "tm-lode-bucket"
}