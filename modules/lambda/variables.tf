variable "project_name" {
  type        = string
  description = "Project name prefix"
}

variable "lambda_role_arn" {
  type        = string
  description = "IAM role ARN for Lambda"
}

variable "subnet_ids" {
  description = "List of subnet IDs for the Lambda function"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID for the Lambda function"
  type        = string
}
