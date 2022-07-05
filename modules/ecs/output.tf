output "ecs" {
    description = "ECS Cluster for the project."
    value = aws_ecs_cluster.ecs
}

output "ecs_role" {
    description = "The Task Execution role for the ECS cluster."
    value = aws_iam_role.ecs_execution_role
}

output "task_role" {
    description = "The Task role for the ECS cluster."
    value = aws_iam_role.ecs_task_role
}