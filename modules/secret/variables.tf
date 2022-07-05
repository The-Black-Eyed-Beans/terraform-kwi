variable "env" {
  type = string
  description = "Environment of the project."
}

variable "vpc" {
  type        = any
  description = "The VPC for the project."
}

variable "public" {
  type        = any
  description = "The private subnets of the VPC."
}

variable "private" {
  type        = any
  description = "The private subnets of the VPC."
}

variable "app_security_group" {
  type        = any
  description = "The security group used for the microservices."
}

variable "gateway_security_group" {
  type        = any
  description = "The security group used for the gateway."
}

variable "kubernetes_security_group" {
  type        = any
  description = "The security group used for Kubernetes."
}

variable "app_alb" {
  type = any
  description = "The Application Load Balancer used for the microservices."
}

variable "gateway_alb" {
  type = any
  description = "The Application Load Balancer used for the gateway."
}

variable "ecs" {
    type = any
    description = "The ECS cluster for the project."
}

variable "eks" {
    type = any
    description = "The EKS cluster for the project."
}

variable "ecs_role" {
  type = any
  description = "The Task Execution role of the ECS cluster."
}

variable "task_role" {
  type = any
  description = "The Task role of the ECS cluster."
}

variable "eks_role" {
  type = any
  description = "The Cluster role of the EKS cluster."
}