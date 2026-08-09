variable "project_name" {
  description = "Prefix used for resource names"
  type        = string
}

variable "vpc_cidr" {
  description = "IPv4 CIDR of the VPC"
  type        = string
}

variable "availability_zones" {
  description = "Two availability zones"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDRs of the two public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDRs of the two private subnets"
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "Create one NAT Gateway in public-a"
  type        = bool
}
