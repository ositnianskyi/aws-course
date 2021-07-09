resource "aws_db_instance" "rds_db" {
  allocated_storage    = 10
  engine               = "postgres"
  engine_version       = "9.6"
  instance_class       = "db.t2.micro"
  name                 = var.db_name
  username             = var.RDS_username
  password             = var.RDS_password
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.db_group.id]
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db_subnet_group"
  subnet_ids = [var.private_subnet_1_id, var.private_subnet_2_id]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_security_group" "db_group" {
  name        = "db_group"
  description = "Enable ingress access to db"
  vpc_id = var.VPC_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.3.0/24", "10.0.4.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}