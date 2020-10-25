resource "aws_eks_cluster" "demo" {
  name     = var.cluster_name
  role_arn = var.role_arn
  vpc_config {
    subnet_ids = [var.sub1,var.sub2,var.sub3 ]
  }/*
  depends_on = [
    aws_iam_role_policy_attachment.example-AmazonEKSClusterPolicy,
    ]*/
}

output "endpoint" {
  value = aws_eks_cluster.demo.endpoint
}


output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.demo.certificate_authority[0].data
}


resource "aws_eks_node_group" "example" {
  depends_on= [aws_eks_cluster.demo]
  cluster_name    = var.cluster_name
  node_group_name = "demo"
  node_role_arn   = var.ng_arn
  subnet_ids      = [ var.sub1,var.sub2,var.sub3 ]
  remote_access {
  ec2_ssh_key= var.key
  }
  scaling_config {
    desired_size = 3
    max_size     = 3
    min_size     = 3
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  /*depends_on = [
    aws_iam_role_policy_attachment.example-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.example-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.example-AmazonEC2ContainerRegistryReadOnly,
  ]*/
}


output "vpc_sg_id" {
  depends_on= [aws_eks_cluster.demo]
    value= aws_eks_cluster.demo.vpc_config[0].cluster_security_group_id
}

