output "resources" {
    description = "Secrets Manager secret for the AWS resources used for the project."
    value = aws_secretsmanager_secret.resources
}