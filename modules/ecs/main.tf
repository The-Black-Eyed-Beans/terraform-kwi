resource "aws_iam_role" "ecs_execution_role" {
    name = join("-", ["aline", "kwi", var.env, "ecs", "execution", "role"])
    assume_role_policy = data.aws_iam_policy_document.execution_policy_document.json
}

resource "aws_iam_role" "ecs_task_role" {
    name = join("-", ["aline", "kwi", var.env, "ecs", "task", "role"])
    assume_role_policy = data.aws_iam_policy_document.execution_policy_document.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
    role = aws_iam_role.ecs_execution_role.name
}

resource "aws_iam_role_policy_attachment" "eks_ec2_container_registry_policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    role = aws_iam_role.ecs_execution_role.name
}

resource "aws_iam_role_policy_attachment" "create_log_group" {
    policy_arn = "arn:aws:iam::086620157175:policy/CreateLogGroupPolicy"
    role = aws_iam_role.ecs_execution_role.name
}

resource "aws_iam_role_policy_attachment" "ecs_access_policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
    role = aws_iam_role.ecs_task_role.name
}

resource "aws_ecs_cluster" "ecs" {
    name = join("-", ["aline", "kwi", var.env, "ecs"])

    setting {
        name = "containerInsights"
        value = "enabled"
    }

    tags = {
        Name = join("-", ["aline", "kwi", var.env, "ecs"])
    }
}

