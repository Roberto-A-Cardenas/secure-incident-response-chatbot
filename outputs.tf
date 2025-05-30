output "public_subnet_id" {
  value = module.vpc.public_subnet_id
}

output "private_subnet_id" {
  value = module.vpc.private_subnet_id
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "lambda_function_name" {
  value = module.lambda.lambda_function_name
}

output "api_endpoint" {
  value = module.api_gateway.api_endpoint
}
