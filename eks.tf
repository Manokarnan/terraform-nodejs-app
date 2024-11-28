module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "nodejs-eks-cluster"
  cluster_version = "1.21"
  vpc_id          = aws_vpc.main_vpc.id
  subnets         = [aws_subnet.public_subnet.id]
  manage_aws_auth = true
}
