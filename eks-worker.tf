resource "aws_iam_role" "iam-eks-node" {
  name = var.iam_eks_node_name

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [ "eks.amazonaws.com", "ec2.amazonaws.com", "acm.amazonaws.com" ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "iam-policy-eks-node" {
  count = length(var.iam_eks_node_policy_arn)

  policy_arn = var.iam_eks_node_policy_arn[count.index]
  role       = aws_iam_role.iam-eks-node.name
}


# WORKER
resource "aws_eks_node_group" "eks-worker-node" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = var.eks_node_group_name
  node_role_arn   = aws_iam_role.iam-eks-node.arn
  subnet_ids      = aws_subnet.subnet.*.id

  instance_types  = var.eks_worker_instance_type

  scaling_config {
    desired_size         = var.eks_worker_desired_capacity
    max_size             = var.eks_worker_max_size
    min_size             = var.eks_worker_min_size
  }

  tags = {
    "Name"                                      = var.eks_auto_scaling_group_name
    #"kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.iam-policy-eks-node
  ]
}





# data "aws_ami" "eks-worker" {
#    filter {
#      name   = "name"
#      values = ["amazon-eks-node-${aws_eks_cluster.eks.version}-v*"]
#    }

#    most_recent = true
#    owners      = [ var.eks_worker_ami_owner_canonical ]
# }

# EKS currently documents this required userdata for EKS worker nodes to
# properly configure Kubernetes applications on the EC2 instance.
# We implement a Terraform local here to simplify Base64 encoding this
# information into the AutoScaling Launch Configuration.
# More information: https://docs.aws.amazon.com/eks/latest/userguide/launch-workers.html
# locals {
#   eks-node-userdata = <<USERDATA
# #!/bin/bash
# set -o xtrace
# /etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.eks.endpoint}' --b64-cluster-ca '${aws_eks_cluster.eks.certificate_authority[0].data}' '${var.cluster_name}'
# USERDATA

# }

# resource "aws_launch_configuration" "eks-launch-config" {
#   associate_public_ip_address = true
#   #iam_instance_profile        = aws_iam_instance_profile.demo-node.name
#   image_id                    = data.aws_ami.eks-worker.id
#   instance_type               = var.eks_worker_instance_type
#   name_prefix                 = var.eks_launch_config_prefix
#   security_groups             = [ aws_security_group.security-group-node.id ]
#   user_data_base64            = base64encode(local.eks-node-userdata)

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# resource "aws_autoscaling_group" "eks-auto-scaling-group" {
#   desired_capacity     = var.eks_worker_desired_capacity
#   launch_configuration = aws_launch_configuration.eks-launch-config.id
#   max_size             = var.eks_worker_max_size
#   min_size             = var.eks_worker_min_size
#   name                 = var.eks_auto_scaling_group_name
#   vpc_zone_identifier  = aws_subnet.subnet.*.id

#   tag {
#     key                 = "Name"
#     value               = var.eks_auto_scaling_group_name
#     propagate_at_launch = true
#   }

#   tag {
#     key                 = "kubernetes.io/cluster/${var.cluster_name}"
#     value               = "owned"
#     propagate_at_launch = true
#   }
# }