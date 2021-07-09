resource "aws_internet_gateway" "gw" {
  vpc_id = var.VPC_id
}

resource "aws_route_table" "private_routes" {
  vpc_id = var.VPC_id

  route {
    cidr_block = "0.0.0.0/0"
    instance_id = var.NAT_id
  }
}

resource "aws_route_table" "public_routes" {
  vpc_id = var.VPC_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "public_rt_1" {
  subnet_id      = var.public_subnet_1_id
  route_table_id = aws_route_table.public_routes.id
}

resource "aws_route_table_association" "public_rt_2" {
  subnet_id      = var.public_subnet_2_id
  route_table_id = aws_route_table.public_routes.id
}

resource "aws_route_table_association" "private_rt_1" {
  subnet_id      = var.private_subnet_1_id
  route_table_id = aws_route_table.private_routes.id
}

resource "aws_route_table_association" "private_rt_2" {
  subnet_id      = var.private_subnet_2_id
  route_table_id = aws_route_table.private_routes.id
}