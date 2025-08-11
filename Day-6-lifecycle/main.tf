resource "aws_instance" "name" {
    ami = "ami-08a6efd148b1f7504"
    instance_type = "t3.micro"
   subnet_id     = "subnet-072e4db16e1508f97" 
   availability_zone = "us-east-1b"
   tags = {
     name="dev"
   }

  lifecycle {
    #prevent_destroy = true
    #create_before_destroy = true
    #ignore_changes = [ tags ,]
  }
}
