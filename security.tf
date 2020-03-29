
resource "aws_security_group" "security-group-cluster" {
  name        = var.security_group_cluster_name
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.security_group_cluster_name
  }
}


resource "aws_security_group" "security-group-node" {
  name        = var.security_group_node_name
  description = "Security group for all nodes in the cluster"
  vpc_id      = aws_vpc.vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name"                                      = var.security_group_node_name
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_security_group_rule" "security-group-role-node" {
  description              = "Allow node to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.security-group-node.id
  source_security_group_id = aws_security_group.security-group-node.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "security-group-role-cluster" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = aws_security_group.security-group-node.id
  source_security_group_id = aws_security_group.security-group-cluster.id
  to_port                  = 65535
  type                     = "ingress"
 }

 resource "aws_security_group_rule" "security-group-role-https" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.security-group-cluster.id
  source_security_group_id = aws_security_group.security-group-node.id
  to_port                  = 443
  type                     = "ingress"
}