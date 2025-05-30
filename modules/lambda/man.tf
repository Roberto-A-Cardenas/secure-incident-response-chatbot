resource "aws_security_group" "lambda_sg" {
  name        = "${var.project_name}-lambda-sg"
  description = "Security group for Lambda function"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-lambda-sg"
  }
}


resource "aws_lambda_function" "incident_handler" {
  function_name = "${var.project_name}-handler"
  role          = var.lambda_role_arn
  handler       = "handler.lambda_handler"
  runtime       = "python3.11"
  timeout       = 10

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  environment {
    variables = {
      LOG_LEVEL = "INFO"
    }
  }

  tags = {
    Name = "${var.project_name}-lambda"
  }
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/src"
  output_path = "${path.module}/src/lambda.zip"
}
