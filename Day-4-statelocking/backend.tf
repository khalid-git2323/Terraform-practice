terraform {
  backend "s3" {
    bucket = "tessss11111"
    key = "day-4/terraform.tfstate"
    region = "us-east-1"
    #use_lockfile = true #s3 support this features but terraform versions >1.10, latest version>=1.10
    dynamodb_table = "test" #this method used for any versions 
    encrypt =true
  }
}