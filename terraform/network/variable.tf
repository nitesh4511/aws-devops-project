variable "vpc" {
  
  default = "devops_project"
}

variable "cidr_range" {
  default = "10.0.0.0/16"
  type = string
}

variable "public_subnet" {
  type =list(string)
  description = "Public subnet CIDR value"
  default = [ "10.0.1.0/24", "10.0.2.0/24" ]
}

variable "private_subnet" {
  type =list(string)
  description = "private subnet CIDR value"
  default = [ "10.0.3.0/24", "10.0.4.0/24" ]
}

variable "availability_zones" {
 type        = list(string)
 description = "Availability Zones"
 default     = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
}