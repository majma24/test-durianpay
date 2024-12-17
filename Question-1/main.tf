# VPC Creation
resource "aws_vpc" "khalis_vpc" {
  cidr_block = "10.1.0.0/16"

  tags = {
    Name = "khalis_vpc"
  }
}

# Create Public Subnet
resource "aws_subnet" "public_subnet" {
  depends_on = [
    aws_vpc.khalis_vpc
  ]
  vpc_id = aws_vpc.khalis_vpc.id
  
  # IP Range of this subnet
  cidr_block = "10.1.1.0/24"
  availability_zone = "ap-southeast-1a"
  # Enabling automatic public IP assignment on instance launch!
  map_public_ip_on_launch = true

  tags = {
    Name = "Khalis Public Subnet"
  }
}

# Creating Private subnet
resource "aws_subnet" "private_subnet" {
  depends_on = [
    aws_vpc.khalis_vpc,
    aws_subnet.public_subnet
  ]  
  # VPC in which subnet has to be created!
  vpc_id = aws_vpc.khalis_vpc.id  
  # IP Range of this subnet
  cidr_block = "10.1.2.0/24"  
  availability_zone = "ap-southeast-1b"
  
  tags = {
    Name = "Khalis Private Subnet"
  }
}

# Internet Gateway for Public Subnet
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.khalis_vpc.id

  tags = {
    Name = "Khalis_main_igw"
  }

  depends_on = [
    aws_vpc.khalis_vpc,
    aws_subnet.public_subnet,
    aws_subnet.private_subnet
  ]  
}

# Creating an Route Table for the public subnet
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.khalis_vpc.id

  tags = {
    Name = "Khalis_public_rt"
  }
}

# Creating an Route Table for the public subnet
resource "aws_route" "public_internet_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id

  depends_on = [
    aws_vpc.khalis_vpc,
    aws_internet_gateway.igw
  ]
}

# Associate Public Subnet with Route Table
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id

  depends_on = [ 
    aws_vpc.khalis_vpc,
    aws_internet_gateway.igw,
    aws_route.public_internet_route
  ]
}

# Creating an Elastic IP for the NAT Gateway!
resource "aws_eip" "khalis_nat_eip" {
  domain = "vpc"
}

# Create NAT Gateway
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.khalis_nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "Khalis_nat_gw"
  }

  depends_on = [ 
    aws_eip.khalis_nat_eip,
   ]
}

# Create Private Route Table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.khalis_vpc.id

  tags = {
    Name = "Khalis private_rt"
  }
}

# Route for NAT Gateway in Private Subnet
resource "aws_route" "private_nat_route" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw.id
}

# Associate Private Subnet with Route Table
resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}

# Launch Template for EC2 Instances
resource "aws_launch_template" "asg_lt" {
  name_prefix   = "asg_lt"
  image_id      = "ami-012088614f199e3a9" # Replace with desired AMI ID
  instance_type = "t2.medium"

  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "asg_instance"
    }
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "asg" {
  vpc_zone_identifier = [aws_subnet.private_subnet.id]

  desired_capacity = 2
  min_size         = 2
  max_size         = 5

  launch_template {
    id      = aws_launch_template.asg_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Khalis-EC2-intance"
    value               = "asg_instance"
    propagate_at_launch = true
  }
}
