# COMMON

variable "region" {
  type        = string
  description = "AWS region to deploy into"
  default     = "eu-central-1"
}


# NETWORK

variable "cidr" {
  type        = map(number)
  description = "FQ VPC CIDR block"
  default = {
    "A"   = 10,
    "B"   = 120,
    "C"   = 0,
    "D"   = 0,
    "NET" = 20
  }
}

variable "vpc_name" {
  type        = string
  description = "Name tag of the VPC"
  default     = "terraform-eks-cluster"
}

variable "subnet_count" {
  type        = number
  description = "Number of subnets to provision"
  default     = 2
}

variable "subnet_netbit" {
  type        = number
  description = "Netbit number of subnets to provision (e.g.: X.X.X.X/24 <-- subnet_netbit)"
  default     = 24
}

variable "subnet_name" {
  type        = string
  description = "Name tag of the subnet"
  default     = "terraform-eks"
}

variable "igw_name" {
  type        = string
  description = "Name tag of the internet gateway"
  default     = "terraform-eks"
}


# SECURITY

variable "security_group_cluster_name" {
  type        = string
  description = "Name tag of the security group for the cluster to worker communication"
  default     = "terraform-eks-cluster-sg"
}

variable "security_group_node_name" {
  type        = string
  description = "Name tag of the security group for the node to worker communication"
  default     = "terraform-eks-node-sg"
}


# EKS

variable "cluster_name" {
  type        = string
  description = "EKS Cluster name"
  default     = "eks-cluster"
}

variable "iam_eks_node_name" {
  type        = string
  description = "EKS Cluster IAM role name"
  default     = "terraform-eks-node"
}

variable "eks_cluster_log_types" {
  type        = list(string)
  description = "EKS Cluster enabled log types to Cloudwatch"
  default     = ["scheduler", "controllerManager"]
}

variable "iam_eks_cluster_name" {
  type        = string
  description = "EKS Cluster IAM role name"
  default     = "terraform-eks-cluster"
}

variable "iam_eks_cluster_policy_arn" {
  type        = list(string)
  description = "List of Policies to attach to the EKS cluster role"
  default = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  ]
}


# EKS WORKERS

variable "eks_node_group_name" {
  type        = string
  description = "EKS Worker node group name"
  default     = "terraform-eks-ng"
}

variable "eks_worker_instance_type" {
  type        = list(string)
  description = "EKS Worker node EC2 instance type"
  default     = [ "t3.large" ]
}

variable "eks_auto_scaling_group_name" {
  type        = string
  description = "EKS Worker node auto scaling group name"
  default     = "terraform-eks"
}

variable "eks_worker_desired_capacity" {
  type        = number
  description = "EKS Worker nodes desired count"
  default     = 3
}

variable "eks_worker_min_size" {
  type        = number
  description = "EKS Worker nodes minimum nodes"
  default     = 2
}

variable "eks_worker_max_size" {
  type        = number
  description = "EKS Worker nodes maximum nodes"
  default     = 5
}

variable "iam_eks_node_policy_arn" {
  type        = list(string)
  description = "List of Policies to attach to the EKS node role"
  default = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSServicePolicy",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess",
    "arn:aws:iam::aws:policy/AmazonRoute53FullAccess"
  ]
}
