variable "region" {
    default="ap-south-1"
}

variable "eks_cluster_name" {
    description="name of cluster"
}

variable "vpc-name" {
    default="eks-vpc"
}
variable "cluster_name" {
    default= "eks-demo"
}

variable "key" {
    default= "mykey"
}

variable "db_name" {
    description= "enter DB name"
}
variable "db_pass" {
    description="enter password"
}
variable "db_uname" {
    description="enter uname"
}