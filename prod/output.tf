output "region" {
    value = data.aws_region.current.name
}

output "vpc" {
    value = module.vpc.vpc
}

output "vpc_name" {
    value = module.vpc.vpc.tags.Name
}

output "vpc_cidr" {
    value = module.vpc.vpc.cidr_block
}

output "public" {
    value = module.vpc.public
}

output "public_one_name" {
    value = module.vpc.public["PublicSubnet1"].tags.Name
}

output "public_one_cidr" {
    value = module.vpc.public["PublicSubnet1"].cidr_block
}

output "public_one_az" {
    value = module.vpc.public["PublicSubnet1"].availability_zone
}

output "private" {
    value = module.vpc.private
}

output "private_two_name" {
    value = module.vpc.private["PrivateSubnet2"].tags.Name
}

output "private_two_cidr" {
    value = module.vpc.private["PrivateSubnet2"].cidr_block
}

output "private_two_az" {
    value = module.vpc.private["PrivateSubnet2"].availability_zone
}

output "app_security_group" {
    value = module.vpc.microservice_sg
}

output "gateway_security_group" {
    value = module.vpc.gateway_sg
}

output "kubernetes_security_group" {
    value = module.vpc.kubernetes_sg
}

output "app_load_balancer" {
    value = module.vpc.micro_alb
}

output "app_load_balancer_name" {
    value = module.vpc.micro_alb.name
}

output "gateway_load_balancer" {
    value = module.vpc.gate_alb
}

output "gateway_load_balancer_name" {
    value = module.vpc.gate_alb.name
}

output "ecs" {
    value = module.ecs.ecs
}

output "ecs_name" {
    value = module.ecs.ecs.name
}

output "ecs_role" {
    value = module.ecs.ecs_role
}

output "ecs_role_name" {
    value = module.ecs.ecs_role.name
}

output "task_role" {
    value = module.ecs.task_role
}

output "task_role_name" {
    value = module.ecs.task_role.name
}

output "eks" {
    value = module.eks.eks
}

output "eks_name" {
    value = module.eks.eks.id
}

output "eks_role" {
    value = module.eks.eks_role
}

output "eks_role_name" {
    value = module.eks.eks_role.name
}

output "resources_secrets" {
    value = module.secret.resources
}