resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "equilux-service-vpc"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "equilux-service-igw"
  }
}

resource "aws_subnet" "public" {
  count = 1
  vpc_id     = aws_vpc.this.id
  cidr_block = cidrsubnet(var.vpc_cidr, 8, count.index + 1) 
  map_public_ip_on_launch = true
  tags = {
    Name = "equilux-service-public-subnet"
  }
  
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_subnet" "private" {
  count = 1
  vpc_id     = aws_vpc.this.id
  cidr_block = cidrsubnet(var.vpc_cidr, 8, count.index + 2) 
  map_public_ip_on_launch = false
  tags = {
    Name = "equilux-service-private-subnet"
  }
}

resource "aws_security_group" "ecs" {
  name        = "ecs_security_group"
  description = "Security group for ECS tasks"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags = {
    Name = "equilux-service-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_vpc_endpoint" "ecs" {
  vpc_id             = aws_vpc.this.id
  service_name       = "com.amazonaws.${var.aws_region}.ecs"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = aws_subnet.public[*].id
  security_group_ids = [aws_security_group.ecs.id]
  private_dns_enabled = true
  depends_on = [aws_subnet.public]
  
  tags = {
    Name = "equilux-ecs-endpoint"
  }
}

resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id             = aws_vpc.this.id
  service_name       = "com.amazonaws.${var.aws_region}.ecr.api"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = aws_subnet.public[*].id
  security_group_ids = [aws_security_group.ecs.id]
  private_dns_enabled = true
  depends_on = [aws_subnet.public]
  
  tags = {
    Name = "equilux-ecr-api-endpoint"
  }
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id             = aws_vpc.this.id
  service_name       = "com.amazonaws.${var.aws_region}.ecr.dkr"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = aws_subnet.public[*].id
  security_group_ids = [aws_security_group.ecs.id]
  private_dns_enabled = true
  depends_on = [aws_subnet.public]
  
  tags = {
    Name = "equilux-ecr-dkr-endpoint"
  }
}

resource "aws_vpc_endpoint" "logs" {
  vpc_id             = aws_vpc.this.id
  service_name       = "com.amazonaws.${var.aws_region}.logs"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = aws_subnet.public[*].id
  security_group_ids = [aws_security_group.ecs.id]
  private_dns_enabled = true
  depends_on = [aws_subnet.public]
  
  tags = {
    Name = "equilux-logs-endpoint"
  }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id             = aws_vpc.this.id
  service_name       = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type  = "Gateway"
  route_table_ids    = [aws_route_table.public.id]
  depends_on = [aws_route_table.public]
  
  tags = {
    Name = "equilux-s3-endpoint"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
