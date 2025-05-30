module "iam" {
  source       = "./modules/iam"
  project_name = var.project_name
}

output "lambda_role_arn" {
  value = module.iam.lambda_role_arn
}

module "lambda" {
  source           = "./modules/lambda"
  project_name     = var.project_name
  lambda_role_arn  = module.iam.lambda_role_arn

  subnet_ids       = [module.vpc.private_subnet_id]
  vpc_id           = module.vpc.vpc_id
}

module "api_gateway" {
  source        = "./modules/api-gateway"
  project_name  = var.project_name
  lambda_arn    = module.lambda.lambda_arn
  lambda_name   = module.lambda.lambda_function_name
}

module "vpc" {
  source               = "./modules/vpc"
  project_name         = var.project_name
  availability_zone    = "us-east-1a"
}
