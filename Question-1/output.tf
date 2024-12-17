# VPC ID
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.khalis_vpc.id
}

# Public Subnet ID
output "public_subnet_id" {
  description = "The ID of the public subnet"
  value       = aws_subnet.public_subnet.id
}

# Private Subnet ID
output "private_subnet_id" {
  description = "The ID of the private subnet"
  value       = aws_subnet.private_subnet.id
}

# Internet Gateway ID
output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.igw.id
}

# NAT Gateway ID
output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = aws_nat_gateway.nat_gw.id
}

# Elastic IP for NAT Gateway
output "nat_gateway_eip" {
  description = "The Elastic IP associated with the NAT Gateway"
  value       = aws_eip.khalis_nat_eip.public_ip
}

# Public Route Table ID
output "public_route_table_id" {
  description = "The ID of the public route table"
  value       = aws_route_table.public_rt.id
}

# Private Route Table ID
output "private_route_table_id" {
  description = "The ID of the private route table"
  value       = aws_route_table.private_rt.id
}

# Launch Template ID
output "launch_template_id" {
  description = "The ID of the EC2 Launch Template"
  value       = aws_launch_template.asg_lt.id
}

# Auto Scaling Group Name
output "asg_name" {
  description = "The name of the Auto Scaling Group"
  value       = aws_autoscaling_group.asg.name
}

# Auto Scaling Group Desired Capacity
output "asg_desired_capacity" {
  description = "The desired number of instances in the Auto Scaling Group"
  value       = aws_autoscaling_group.asg.desired_capacity
}

# Auto Scaling Group Subnet IDs
output "asg_vpc_zone_identifier" {
  description = "The subnet IDs where Auto Scaling Group instances are launched"
  value       = aws_autoscaling_group.asg.vpc_zone_identifier
}
