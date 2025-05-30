resource "aws_iam_role" "lambda_exec_role" {
  name = "${var.project_name}-lambda-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
  tags = {
    Name = "${var.project_name}-lambda-role"
  }
}

resource "aws_iam_policy" "lambda_basic_logging" {
  name        = "${var.project_name}-lambda-logs"
  description = "Allows Lambda to write to CloudWatch Logs"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
		  "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface",
		  "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:FilterLogEvents",
		  "guardduty:ListDetectors",
          "guardduty:GetFindings",
		  "guardduty:ListFindings"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_logs_attach" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.lambda_basic_logging.arn
}
