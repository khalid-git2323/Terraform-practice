provider "aws" {
  
}

resource "aws_instance" "name" {
  ami = "ami-08a6efd148b1f7504"
  instance_type = "t3.micro"
  subnet_id     = "subnet-072e4db16e1508f97" 
depends_on = [ aws_s3_bucket.name ]
}

resource "aws_s3_bucket" "name" {
    
    bucket="tesssdddndhdhh1232"
  
}