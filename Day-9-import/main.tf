resource "aws_instance" "name" {
  ami = "ami-01102c5e8ab69fb75"
  instance_type = "t3.micro"
  tags = {
    name="dev"
  }
}
#This is command----terraform import aws_instance.name ami-01102c5e8ab69fb75 make sure the instanceshould be already exist

resource "aws_s3_bucket" "name" {
  bucket = "mycusttttttttttsssss"
}
#This is command----terraform import aws_s3_bucket.name  mycusttttttttttsssss make sure the bucket need to already exist

resource "aws_iam_user" "name" {
  name = "Terraform"
}