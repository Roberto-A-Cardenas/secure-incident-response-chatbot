variable "project_name" {
  description = "Prefix for all resources"
  type        = string
}

variable "lambda_arn" {
  description = "ARN of the Lambda to invoke"
  type        = string
}

variable "lambda_name" {
  description = "Name of the Lambda to grant invoke permission"
  type        = string
}
