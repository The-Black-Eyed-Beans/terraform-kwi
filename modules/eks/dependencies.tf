data "aws_iam_policy_document" "cluster_policy_document" {
    version = "2012-10-17"
    statement {
        effect = "Allow"
        actions = ["sts:AssumeRole"]
        principals {
            identifiers = ["eks.amazonaws.com"]
            type = "Service"
        }
    }
}