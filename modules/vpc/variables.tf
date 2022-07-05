variable "env" {
  type = string
  description = "Environment of the project."
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC."
}

variable "vpc_sg" {
  type        = list(number)
  description = "Security group ports used within the VPC."
}

variable "public" {
  type        = map(object({
    cidr_block = string
    tag_name = string
    az = string
  }))
  description = "Subnets used for the VPC."
}

variable "private" {
  type        = map(object({
    cidr_block = string
    tag_name = string
    az = string
  }))
  description = "Subnets used for the VPC."
}

variable "route53_domain" {
  type = string
  description = "Domain name used by Route53."
}