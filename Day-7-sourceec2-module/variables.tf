variable "ami_id" {
  description = "AMI ID for EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "instance_name" {
  description = "Tag name for EC2 instance"
  type        = string
  default     = "MyEC2"
}
variable "vpc" {
    type = string
    default = ""
  
}

