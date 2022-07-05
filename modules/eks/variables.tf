variable "env" {
  type = string
  description = "Environment of the project."
}

variable "private" {
  type        = any
  description = "The private subnets of the VPC."
}