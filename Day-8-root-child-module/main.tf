module "vpc" {
  source = "./module/vpc"
  cidr_block = "10.0.0.0/16"
  subnet_cidr = "10.0.1.0/24"
  az = "us-west-2a"
}

module "ec2" {
    source = "./module/ec2"
    ami_id = "ami-01102c5e8ab69fb75"
    instance_type = "t3.micro"
  
}
module "s3" {
  source = "./module/s3"
  bucket_name = "mycusttttttttttsssss"
}