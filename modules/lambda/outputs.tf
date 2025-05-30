output "lambda_function_name" {
  value = aws_lambda_function.incident_handler.function_name
}

output "lambda_arn" {
  value = aws_lambda_function.incident_handler.arn
}
