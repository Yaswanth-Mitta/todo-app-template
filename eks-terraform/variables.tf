# eks-terraform/variables.tf

variable "cluster_name" {
  description = "The name for the EKS cluster."
  type        = string
  default     = "simple-todo-app-cluster"
}

variable "instance_type" {
  description = "The EC2 instance type for the EKS worker nodes."
  type        = string
  default     = "t3.medium"
}

variable "min_size" {
  description = "The minimum number of worker nodes in the EKS node group."
  type        = number
  default     = 1
}

variable "max_size" {
  description = "The maximum number of worker nodes in the EKS node group."
  type        = number
  default     = 3
}

variable "desired_size" {
  description = "The desired number of worker nodes in the EKS node group."
  type        = number
  default     = 2
}

variable "key_name" {
  description = "The EC2 key pair name for SSH access to the nodes."
  type        = string
  default     = "mitta-ore"
}

