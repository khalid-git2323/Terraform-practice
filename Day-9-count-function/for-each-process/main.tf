resource "aws_instance" "name" {
    ami = "ami-01102c5e8ab69fb75"
    instance_type = "t3.micro"
    for_each = toset(var.ec2)
    #count = length(var.ec2)
    tags = {
      Name = each.value
    }
  
}



variable "ec2" {
    type = list(string)
    default = [ "dev", "prod"]
  
}