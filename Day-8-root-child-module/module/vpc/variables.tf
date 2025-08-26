variable "cidr_block" {
  type = string
  description = "vpc cidr block"
  default = ""
}
variable "subnet_cidr" {
  type = string
  description = "subnet id value"
  default = ""
}
variable "az" {
  type = string
  description = "zone"
  default = ""
}