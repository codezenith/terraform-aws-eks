# EKS Terraform Template

This Elastic Kubernetes Service template for AWS will provision a public reachable Kubernetes cluster (API endpoint public) plus some network resources so that Kubernetes can run properly.

## Which resources will be created?

___Network Stack___:

* VPC
* X amount of subnets (subnets will all be public)
* Internet Gateway
* Route tables to route 0.0.0.0/0 traffic into the subnets
* Security Groups for Cluster <--> Node communication

___Kubernetes Infrastructure___:

* EKS cluster with public API endpoint
* X amount of worker nodes with configurable compute size

By default the worker nodes have access to the AWS Certificate Manager (ACM) to pull TLS certificates. The EKS cluster is also allowed to generate Route53 ingress to the cluster (setup ingress e.g.: using helm charts).
