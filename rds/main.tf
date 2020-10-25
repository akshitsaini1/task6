resource "aws_db_subnet_group" "default" {
  name       = "eks-db"
  subnet_ids = [var.sub1,var.sub2,var.sub3]

  tags = {
    Name = "eks db subnet group"
  }
}

resource "aws_db_instance" "default" {
  depends_on=[ aws_db_subnet_group.default ]
  allocated_storage    = 20
  db_subnet_group_name = aws_db_subnet_group.default.name
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = var.db_name
  skip_final_snapshot  = "true"
  username             = var.db_uname
  password             = var.db_pass
  parameter_group_name = "default.mysql5.7"
  vpc_security_group_ids= [ var.vpc_sg_id ]
}

output "db_endpoint" {
    value= aws_db_instance.default.endpoint
}
