
provider "aws" {
    region =var.region
    profile ="Akshit"
}
provider "kubernetes" {  
}

module "role" {
  source= "./role"
}

module "vpc" {
  source = "./vpc"
  cluster_name=var.eks_cluster_name

  vpc_name=var.vpc-name
}

module "eks_cluster" {
  source="./eks-cluster"
  depends_on=[module.vpc,module.role]
  cluster_name=var.eks_cluster_name
  role_arn=module.role.arn
  ng_arn=module.role.ng_arn
  sub1=module.vpc.sub1_id
  sub2=module.vpc.sub2_id
  sub3=module.vpc.sub3_id
  key=var.key
}


/*
data "aws_availability_zones" "available" {
  state = "available"
}*/

resource "null_resource" "local-exec" {
    depends_on = [ module.eks_cluster ]
    provisioner "local-exec" {
    command =  "aws eks --region ${var.region} update-kubeconfig --name ${var.eks_cluster_name}"

    }
}

module "rds" {
  source= "./rds"
  depends_on=[module.eks_cluster]
  sub1=module.vpc.sub1_id
  sub2=module.vpc.sub2_id
  sub3=module.vpc.sub3_id
  db_name=var.db_name
  db_pass=var.db_pass
  db_uname=var.db_uname
  cluster_name=var.eks_cluster_name
  vpc_sg_id=module.eks_cluster.vpc_sg_id
}

module "kubernetes" {
  depends_on= [ module.rds ]
  source="./kubernetes"
  db-host=module.rds.db_endpoint
  db-uname=var.db_name
  db-pass=var.db_pass
  db-dbname=var.db_name
}

/*
data "aws_availability_zones" "available" {
  state = "available"
}
*/

/*
output "res" {
  depends_on = [ module.eks_cluster ]
  value= module.eks_cluster.vpc_sg_id
}

output "db_enpoint" {
  depends_on= [ module.rds ]
  value=module.rds.db_endpoint
}
*/

output "lb" {
  depends_on=[module.kubernetes]
  value=module.kubernetes.endpoint
}
