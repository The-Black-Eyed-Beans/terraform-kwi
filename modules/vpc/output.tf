output "vpc" {
    description = "VPC for project."
    value = aws_vpc.vpc
}

output "public" {
    description = "Public subnets of the VPC."
    value = aws_subnet.public
}

output "private" {
    description = "Private subnets of the VPC."
    value = aws_subnet.private
}

output "gateway" {
    description = "Internet gateway of the VPC."
    value = aws_internet_gateway.gateway
}

output "nat" {
    description = "NAT gateway of the VPC."
    value = aws_nat_gateway.nat_gateway
}

output "microservice_sg" {
    description = "Security group for the microservices."
    value = aws_security_group.ms_sg
}

output "gateway_sg" {
    description = "Security group for the gateway."
    value = aws_security_group.gate_sg
}

output "kubernetes_sg" {
    description = "Security group for Kubernetes."
    value = aws_security_group.k8s_sg
}

output "micro_alb" {
    description = "Application Load Balancer for the microservices."
    value = aws_lb.microservice_alb
}

output "gate_alb" {
    description = "Application Load Balancer for the gateway."
    value = aws_lb.gateway_alb
}