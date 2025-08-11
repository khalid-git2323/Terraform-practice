provider "aws" {
  
}

resource "aws_instance" "name" {
  ami = "ami-08a6efd148b1f7504"
  instance_type = "t3.micro"
  subnet_id = "subnet-072e4db16e1508f97"
  tags = {
    name="dev"
  }

  user_data = file("user.sh")

}

