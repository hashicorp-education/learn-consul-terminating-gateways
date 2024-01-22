data "aws_db_instance" "database" {
  db_instance_identifier = local.name
}

resource "aws_db_instance" "database" {
  identifier           = local.name
  allocated_storage    = 6
  engine               = "postgres"
  engine_version       = var.postgres_version
  instance_class       = "db.t4g.small"
  db_name              = "products"
  username             = "postgres"
  password             = "password"
  port                 = 5432
  #parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  multi_az             = false

  db_subnet_group_name   = module.vpc.database_subnet_group_name
  vpc_security_group_ids = [module.security_group.security_group_id]

  depends_on = [module.vpc, module.security_group]
}

################################################################################
# Supporting Resources
################################################################################

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = local.name
  description = "PostgreSQL security group"
  vpc_id      = module.vpc.vpc_id

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      description = "PostgreSQL access from within VPC"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
  ]
}