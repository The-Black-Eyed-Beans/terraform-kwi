resource "aws_secretsmanager_secret" "resources" {
    name = join("/", ["aline-kwi", var.env, "secrets", "resources"])
    recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "version" {
    secret_id = aws_secretsmanager_secret.resources.id
    secret_string = <<EOF
    {
        "VpcId": "${var.vpc.id}",
        "AppLoadBalancerArn": "${var.app_alb.arn}",
        "AppLoadBalancerDns": "${var.app_alb.dns_name}",
        "GatewayLoadBalancerArn": "${var.gateway_alb.arn}",
        "GatewayLoadBalancerDns": "${var.gateway_alb.dns_name}",
        %{for key, subnet in var.public ~}
        "${key}": "${subnet.id}",
        %{endfor ~}
        %{for key, subnet in var.private ~}
        "${key}": "${subnet.id}",
        %{endfor ~}
        "AppSecurityGroup": "${var.app_security_group.id}",
        "GatewaySecurityGroup": "${var.gateway_security_group.id}",
        "KubernetesSecurityGroup": "${var.kubernetes_security_group.id}",
        "EcsCluster": "${var.ecs.id}",
        "EksCluster": "${var.eks.arn}",
        "TaskExecutionRole": "${var.ecs_role.arn}",
        "TaskRole": "${var.task_role.arn}",
        "ClusterRole": "${var.eks_role.arn}"
    }
EOF
}