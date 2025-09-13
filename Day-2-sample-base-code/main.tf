resource "aws_instance" "name" {
    ami = "ami-0a94a1259c5779e00"
    instance_type = "t3.micro"
  
}
resource "aws_s3_bucket" "my_bucket"{
  bucket="lambdajamadar12312"
}
