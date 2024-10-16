provider "aws" {
  region = "us-east-1" 
}

# 2.1 Create the VPC
resource "aws_vpc" "rds_vpc" {
  cidr_block = "10.0.0.0/24"
}

# 2.2 Create the subnets
resource "aws_subnet" "rds_subnet_a" {
  vpc_id            = aws_vpc.rds_vpc.id
  cidr_block        = "10.0.0.0/25"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "rds_subnet_b" {
  vpc_id            = aws_vpc.rds_vpc.id
  cidr_block        = "10.0.0.128/25"
  availability_zone = "us-east-1b"
}

# 2.3 Create DB Subnet Group
resource "aws_db_subnet_group" "rds_db_subnet_group" {
  name       = "demodbsubnetgroup"
  subnet_ids = [aws_subnet.rds_subnet_a.id, aws_subnet.rds_subnet_b.id]
  description = "Demo DB Subnet Group"
}

# 2.4 Create a VPC Security Group
resource "aws_security_group" "rds_security_group" {
  name        = "demordssecuritygroup"
  description = "Demo RDS security group"
  vpc_id      = aws_vpc.rds_vpc.id

}

resource "aws_security_group_rule" "allow_mysql_access" {
  type              = "ingress" # Specify that this is an ingress rule
  from_port         = 3306       # The starting port for the rule
  to_port           = 3306       # The ending port for the rule
  protocol          = "tcp"      # The protocol to use (TCP)
  security_group_id = aws_security_group.rds_security_group.id # The security group ID for your RDS instance
  cidr_blocks       = ["192.168.0.0/16"] # The CIDR block to allow access from
}


# 2.5 Create a DB Instance in the VPC
resource "aws_db_instance" "mariadb_apm" {
  db_name                 = "apm_db"
  identifier              = "mariadb-apm"
  allocated_storage        = 10
  instance_class          = "db.t3.micro"
  engine                 = "mariadb"
  engine_version         = "10.5"
  username               = "apmrdsuser"
  password               = "apmrdspassword" # Use sensitive variable
  publicly_accessible     = false
  vpc_security_group_ids  = [aws_security_group.rds_security_group.id]
  db_subnet_group_name    = aws_db_subnet_group.rds_db_subnet_group.name
  availability_zone       = aws_subnet.rds_subnet_b.availability_zone
  port                    = 3306
  tags = {
    product = "apm"
  }
}

resource "aws_db_instance" "mariadb_bugs" {
  db_name                 = "bugs_db"
  identifier              = "mariadb-bugs"
  allocated_storage        = 10
  instance_class          = "db.t3.micro"
  engine                 = "mariadb"
  engine_version         = "10.5"
  username               = "bugsrdsuser"
  password               = "bugsrdspassword" # Use sensitive variable
  publicly_accessible     = false
  vpc_security_group_ids  = [aws_security_group.rds_security_group.id]
  db_subnet_group_name    = aws_db_subnet_group.rds_db_subnet_group.name
  availability_zone       = aws_subnet.rds_subnet_b.availability_zone
  port                    = 3306
  tags = {
    product = "bugs"
  }
}

resource "aws_db_instance" "mariadb_crashes" {
  db_name                 = "crashes_db"
  identifier              = "mariadb-crashes"
  allocated_storage        = 10
  instance_class          = "db.t3.micro"
  engine                 = "mariadb"
  engine_version         = "10.5"
  username               = "crashesrdsuser"
  password               = "crashesrdspassword" # Use sensitive variable
  publicly_accessible     = false
  vpc_security_group_ids  = [aws_security_group.rds_security_group.id]
  db_subnet_group_name    = aws_db_subnet_group.rds_db_subnet_group.name
  availability_zone       = aws_subnet.rds_subnet_b.availability_zone
  port                    = 3306
  tags = {
    product = "crashes"
  }
}

resource "aws_db_instance" "mariadb_core" {
  db_name                 = "core_db"
  identifier              = "mariadb-core"
  allocated_storage        = 10
  instance_class          = "db.t3.micro"
  engine                 = "mariadb"
  engine_version         = "10.5"
  username               = "corerdsuser"
  password               = "corerdspassword" # Use sensitive variable
  publicly_accessible     = false
  vpc_security_group_ids  = [aws_security_group.rds_security_group.id]
  db_subnet_group_name    = aws_db_subnet_group.rds_db_subnet_group.name
  availability_zone       = aws_subnet.rds_subnet_b.availability_zone
  port                    = 3306
  tags = {
    product = "core"
  }
}

resource "aws_db_instance" "mariadb_surveys" {
  db_name                 = "surveys_db"
  identifier              = "mariadb-surveys"
  allocated_storage        = 10
  instance_class          = "db.t3.micro"
  engine                 = "mariadb"
  engine_version         = "10.5"
  username               = "surveysrdsuser"
  password               = "surveysrdspassword" # Use sensitive variable
  publicly_accessible     = false
  vpc_security_group_ids  = [aws_security_group.rds_security_group.id]
  db_subnet_group_name    = aws_db_subnet_group.rds_db_subnet_group.name
  availability_zone       = aws_subnet.rds_subnet_b.availability_zone
  port                    = 3306
  tags = {
    product = "surveys"
  }
}
