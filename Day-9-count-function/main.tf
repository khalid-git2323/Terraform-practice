resource "aws_instance" "name" {
  ami           = "ami-01102c5e8ab69fb75"
  instance_type = "t3.micro"

  count = length(var.ec2)   # number of instances = length of list

  tags = {
    Name = var.ec2[count.index]   # pick a name from the list based on index
  }
}
variable "ec2" {
  type    = list(string)
  default = ["test", "prod"]
}
#length(var.ec2) = 3 → Terraform creates 3 EC2 instances.

#count.index:

#Instance 0 → Name = app-server

#Instance 1 → Name = db-server

#Instance 2 → Name = cache-server