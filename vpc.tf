
data "aws_availability_zones" "available" {}

 resource "aws_vpc" "vpc" {
   cidr_block = "${var.cidr["A"]}.${var.cidr["B"]}.${var.cidr["C"]}.${var.cidr["D"]}/${var.cidr["NET"]}"

   tags = {
     "Name"                                      = var.vpc_name
     "kubernetes.io/cluster/${var.cluster_name}" = "shared"
   }
 }

 resource "aws_subnet" "subnet" {
   count = var.subnet_count

   availability_zone = data.aws_availability_zones.available.names[count.index]
   cidr_block        = "${var.cidr["A"]}.${var.cidr["B"]}.${count.index}.${var.cidr["D"]}/${var.subnet_netbit}"
   vpc_id            = aws_vpc.vpc.id

   tags = {
     "Name"                                      = "${var.subnet_name}-${count.index}"
     "kubernetes.io/cluster/${var.cluster_name}" = "shared"
   }
 }

 resource "aws_internet_gateway" "igw" {
   vpc_id = aws_vpc.vpc.id

   tags = {
     Name = var.igw_name
   }
 }

 resource "aws_route_table" "rt-table" {
   vpc_id = aws_vpc.vpc.id

   route {
     cidr_block = "0.0.0.0/0"
     gateway_id = aws_internet_gateway.igw.id
   }
 }

 resource "aws_route_table_association" "rt-table-assoc" {
   count = var.subnet_count

   subnet_id      = aws_subnet.subnet[count.index].id
   route_table_id = aws_route_table.rt-table.id
 }