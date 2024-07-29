
resource "aws_eks_cluster" "example" {
  name     = "my-eks-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
    security_group_ids = [aws_security_group.eks_cluster_sg.id]
  }
}

resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "eks.amazonaws.com"
        } 
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_role_policy_attachment" {
  role       = aws_iam_role.eks_cluster_role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "my-vpc"
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.example.id
  cidr_block       = "10.0.1.0/24"
  availability_zone = "ap-south-2a"

  tags = {
    Name = "public-subnet-1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.example.id
  cidr_block       = "10.0.2.0/24"
  availability_zone = "ap-south-2b"

  tags = {
    Name = "public-subnet-2"
  }
}

resource "aws_security_group" "eks_cluster_sg" {
  name        = "eks-cluster-sg"
  description = "Security group for EKS cluster"
  vpc_id      = aws_vpc.example.id

  ingress {
    description = "Allow ingress from anywhere on port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow ingress from anywhere on port 443 for HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_instance_profile" "eks_node_instance_profile" {
  name = "eks-node-instance-profile"
  role = aws_iam_role.eks_cluster_role.arn
}

resource "aws_autoscaling_group" "eks_node_group" {
  name               = "eks-node-group"
  vpc_zone_id        = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
  launch_template_id = aws_launch_template.eks_node_launch_template.id
  min_size           = 1
  max_size           = 2
  desired_capacity   = 1

  tags = {
    Name = "eks-node-group"
  }
}

resource "aws_launch_template" "eks_node_launch_template" {
  name_prefix = "eks-node-launch-template"

  image_id = data.aws_ami.amazon_linux.id

  instance_type = "t2.medium"

  iam_instance_profile = aws_iam_instance_profile.eks_node_instance_profile.arn

  key_name = "your-key-pair-name"

  security_groups = [aws_security_group.eks_cluster_sg.id]
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-20230322.0"]
  }
}
