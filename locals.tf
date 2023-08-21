locals {
  cluster_name    = "tf-eks"
  region          = "eu-south-1"
  cluster_version = "1.27"

  ami_type  = "AL2_x86_64"
  disk_size = 30

  instance_type = [
    "m5.large",
  ]

  min_size     = 2
  max_size     = 5
  desired_size = 2

  vpc_cidr            = "10.0.0.0/16"
  vpc_private_subnets = ["10.0.10.0/24", "10.0.20.0/24"]
  vpc_public_subnets  = ["10.0.30.0/24", "10.0.40.0/24"]

  cluster_ip_family         = "ipv4"
  cluster_service_ipv4_cidr = "10.100.0.0/16"

  tags = {
    Terraform = true
  }
}
