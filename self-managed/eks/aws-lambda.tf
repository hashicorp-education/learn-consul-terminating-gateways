resource "aws_iam_role" "lambda" {
  name = "lambda"
  assume_role_policy = jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
            Action = "sts:AssumeRole",
            Effect = "Allow",
            Principal = {
                Service = "lambda.amazonaws.com"
            },
        },
        {
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
                Service = "ec2.amazonaws.com"
            }
        },
      ]
  })
}

resource "aws_lambda_function" "database_init" {
  filename      = "app.zip"
  function_name = "app_name"
  role          = aws_iam_role.lambda.arn
  handler       = "index.handler"

  source_code_hash = filebase64sha256("app.zip")

  runtime = "python3.9"
  environment {
      variables = {
          DB_HOST     = aws_db_instance.database.address
          DB_PORT     = 5432
          DB_DATABASE = aws_db_instance.database.db_name
          DB_USER     = aws_db_instance.database.username
          DB_PASSWORD = aws_db_instance.database.password
      }
  }

  vpc_config {
    subnet_ids         = [module.vpc.private_subnets]
    security_group_ids = [module.vpc.default_security_group_id]
  }

  depends_on = [aws_db_instance.database]
}

output "RDS_address" {
  description = "Address of the RDS instance."
  value       = aws_db_instance.database.address
}

output "lambda_role_arn" {
  description = "ARN of the IAM role used by Lambda."
  value       = aws_iam_role.lambda.arn
}

output "lambda_function_name" {
  description = "The name of the lambda function."
  value       = aws_lambda_function.database_init.function_name
}