data "aws_iam_policy_document" "execution_policy_document" {
    version = "2012-10-17"
    statement {
        effect = "Allow"
        actions = ["sts:AssumeRole"]
        principals {
            identifiers = ["ecs-tasks.amazonaws.com"]
            type = "Service"
        }
    }
}