provider "aws" {
  region = "us-east-1"  # Replace with your desired region
}

# Create a new VPC for Redis
resource "aws_vpc" "redis_vpc" {
  cidr_block = "10.0.0.0/16"  # Adjust the CIDR block as needed
}

# Create a subnet for Redis
resource "aws_subnet" "redis_subnet" {
  vpc_id            = aws_vpc.redis_vpc.id
  cidr_block        = "10.0.1.0/24"  # Adjust the CIDR block as needed
  availability_zone = "us-east-1a"  # Adjust as needed
}

# Create a security group for Redis
resource "aws_security_group" "redis_sg" {
  name        = "redis-sg"
  description = "Allow traffic to Redis"
  vpc_id     = aws_vpc.redis_vpc.id

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Change this to your specific IP range
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # All outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create standalone Redis instance for product: apm
resource "aws_elasticache_cluster" "redis_apm" {
  cluster_id           = "redis-cluster-apm"
  engine               = "redis"
  engine_version       = "6.x"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  port                 = 6379

  security_group_ids   = [aws_security_group.redis_sg.id]
  subnet_group_name    = aws_elasticache_subnet_group.redis_subnet_group.name

  tags = {
    product = "apm"
  }
}

# Create standalone Redis instance for product: crash
resource "aws_elasticache_cluster" "redis_crash" {
  cluster_id           = "redis-cluster-crash"
  engine               = "redis"
  engine_version       = "6.x"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  port                 = 6379

  security_group_ids   = [aws_security_group.redis_sg.id]
  subnet_group_name    = aws_elasticache_subnet_group.redis_subnet_group.name

  tags = {
    product = "crash"
  }
}

# Create standalone Redis instance for product: core-cache
resource "aws_elasticache_cluster" "redis_core_cache" {
  cluster_id           = "redis-cluster-core-cache"
  engine               = "redis"
  engine_version       = "6.x"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  port                 = 6379

  security_group_ids   = [aws_security_group.redis_sg.id]
  subnet_group_name    = aws_elasticache_subnet_group.redis_subnet_group.name

  tags = {
    product = "core-cache"
  }
}

# Create standalone Redis instance for product: core-job
resource "aws_elasticache_cluster" "redis_core_job" {
  cluster_id           = "redis-cluster-core-job"
  engine               = "redis"
  engine_version       = "6.x"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  port                 = 6379

  security_group_ids   = [aws_security_group.redis_sg.id]
  subnet_group_name    = aws_elasticache_subnet_group.redis_subnet_group.name

  tags = {
    product = "core-job"
  }
}

# Create a subnet group for the Redis instances
resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "redis-subnet-group"
  subnet_ids = [aws_subnet.redis_subnet.id]
  description = "Subnet group for Redis instances"
}

# Outputs
output "redis_apm_primary_endpoint" {
  value = aws_elasticache_cluster.redis_apm.configuration_endpoint
}

output "redis_crash_primary_endpoint" {
  value = aws_elasticache_cluster.redis_crash.configuration_endpoint
}

output "redis_core_cache_primary_endpoint" {
  value = aws_elasticache_cluster.redis_core_cache.configuration_endpoint
}

output "redis_core_job_primary_endpoint" {
  value = aws_elasticache_cluster.redis_core_job.configuration_endpoint
}

