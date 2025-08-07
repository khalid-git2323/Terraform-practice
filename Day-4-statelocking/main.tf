resource "aws_instance" "name" {
    ami = "ami-084a7d336e816906b"
    instance_type = "t3.micro"
  tags = {
    name="dev-1"
  }
}