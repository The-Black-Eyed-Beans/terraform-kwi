data "aws_region" "current" {}

module "vpc" {
    source = "../modules/vpc"
    env = var.env
    vpc_cidr = var.vpc_cidr
    vpc_sg = var.vpc_sg
    public = var.public
    private = var.private
    route53_domain = var.route53_domain
}

module "ecs" {
    source = "../modules/ecs"
    env = var.env
}

module "eks" {
    source = "../modules/eks"
    env = var.env
    private = module.vpc.private
}

module "secret" {
    source = "../modules/secret"
    env = var.env
    vpc = module.vpc.vpc
    public = module.vpc.public
    private = module.vpc.private
    app_security_group = module.vpc.microservice_sg
    gateway_security_group = module.vpc.gateway_sg
    kubernetes_security_group = module.vpc.kubernetes_sg
    app_alb = module.vpc.micro_alb
    gateway_alb = module.vpc.gate_alb
    ecs = module.ecs.ecs
    eks = module.eks.eks
    ecs_role = module.ecs.ecs_role
    task_role = module.ecs.task_role
    eks_role = module.eks.eks_role
}