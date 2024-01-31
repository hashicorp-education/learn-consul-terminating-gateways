################################################################################
# AWS Lambda definition
################################################################################

module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"
  version = "4.2.0"

  function_name = "product-db-init"
  description   = "HashiCups DB initialization"
  handler       = "product-db-init.lambda_handler"
  runtime       = "python3.9"

  source_path = "./config/lambda-function"

  environment_variables = {
          DB_HOST     = aws_db_instance.database.address
          DB_PORT     = 5432
          DB_NAME     = aws_db_instance.database.db_name
          DB_USER     = aws_db_instance.database.username
          DB_PASSWORD = aws_db_instance.database.password
  }

  vpc_subnet_ids         = module.vpc.private_subnets
  vpc_security_group_ids = [module.vpc.default_security_group_id]
  attach_network_policy  = true

  depends_on = [aws_db_instance.database]
}

################################################################################
# AWS Lambda invokation
################################################################################

resource "aws_lambda_invocation" "database_init" {
  function_name = module.lambda_function.lambda_function_name

  input = jsonencode({
    key = "db-init"
  })

  depends_on = [module.lambda_function] 
}

output "aws_lambda_result" {
  value = jsondecode(aws_lambda_invocation.database_init.result)
}