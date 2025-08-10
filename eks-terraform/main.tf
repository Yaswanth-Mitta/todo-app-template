# eks-terraform/main.tf

# Configure the AWS Provider
provider "aws" {
  region = "us-west-2" # This line sets the region.
}

# --- VPC and Networking Module ---
# This module provisions a new VPC with public and private subnets.
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.1.0" # A known stable version

  name = "mitta-todo" # The VPC name is now set to mitta-todo
  cidr = "10.0.0.0/16"

  azs             = ["us-west-2a", "us-west-2b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway     = true
  single_nat_gateway     = true
  enable_dns_hostnames   = true

  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

# --- EKS Cluster Module ---
# This module creates the EKS cluster and a managed node group.
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.27.0" # A recent, stable version.

  cluster_name    = var.cluster_name
  cluster_version = "1.29" # Updated to a supported version
  vpc_id          = module.vpc.vpc_id

  # This is the new, required line to fix the coalescelist error.
  # The EKS module needs to know which subnets to use for the control plane.
  subnet_ids = module.vpc.private_subnets

  # This block configures the managed worker nodes.
  eks_managed_node_groups = {
    "todo-app-node-group" = {
      instance_types = [var.instance_type]
      min_size       = var.min_size
      max_size       = var.max_size
      desired_size   = var.desired_size
      
      # The private subnets from the VPC are used for the worker nodes.
      subnet_ids = module.vpc.private_subnets

      # Your SSH key pair name from the variables file.
      key_name   = var.key_name
    }
  }
}

