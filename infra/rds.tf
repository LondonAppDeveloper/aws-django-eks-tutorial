module "db" {
  source     = "terraform-aws-modules/rds/aws"
  version    = "~> 5.9.0"
  identifier = "${var.prefix}-db"

  engine         = "postgres"
  engine_version = "14.7"
  instance_class = "db.t4g.micro"
  family         = "postgres14"

  allocated_storage   = 5
  skip_final_snapshot = true

  db_name                = "djangoproject"
  username               = "djangouser"
  create_random_password = false
  password               = var.db_password

  multi_az               = false
  db_subnet_group_name   = module.vpc.database_subnet_group
  vpc_security_group_ids = [module.rds_security_group.security_group_id]
}

module "rds_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.17.2"

  name        = "${var.prefix}-rds-sg"
  description = "RDS security group"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      description = "PostgreSQL access from within VPC"
      cidr_blocks = module.vpc.vpc_cidr_block
    }
  ]
}
