# Terraform Wrappers

A comprehensive collection of reusable Terraform wrapper modules for AWS infrastructure provisioning. These wrappers simplify and standardize the deployment of common AWS resources while maintaining flexibility and best practices.

## Overview

This project provides Terraform wrapper modules that abstract away complexity while providing a clean interface for provisioning AWS infrastructure. Each wrapper is designed to handle multiple resources of the same type through a map-based configuration approach.

## Available Wrappers

| Wrapper | Description | Use Case |
|---------|-------------|----------|
| **ALB Wrapper** | Application Load Balancer management | Distribute traffic across EC2 instances, containers, or IP targets |
| **CloudFront Wrapper** | CloudFront distribution deployment | CDN and edge caching for content delivery |
| **EC2 Wrapper** | EC2 instance provisioning and configuration | Virtual compute instances with flexible sizing |
| **ECR Wrapper** | Elastic Container Registry management | Docker image storage and management |
| **ECS Wrapper** | Elastic Container Service orchestration | Container deployment and orchestration |
| **IAM Wrapper** | Identity and Access Management setup | Roles, policies, and permissions management |
| **S3 Wrapper** | S3 bucket creation and configuration | Object storage with flexible options |
| **SG Wrapper** | Security Group management | Network traffic control and firewall rules |
| **VPC Wrapper** | VPC and networking infrastructure | Virtual Private Cloud with subnets and routing |

## 🎯 Key Features

✨ **Modular Design** - Each wrapper is independent and can be used standalone  
✨ **Map-Based Configuration** - Deploy multiple resources of the same type easily  
✨ **Flexible Variables** - Optional parameters allow both simple and advanced configurations  
✨ **AWS Region Support** - Currently configured for `ap-south-1` (easily customizable)  
✨ **Terraform 5.0+** - Compatible with latest Terraform and AWS provider versions  
✨ **Tagging Support** - Built-in support for resource tagging and organization  

##  Quick Start

### Prerequisites

- **Terraform** >= 1.0
- **AWS CLI** configured with appropriate credentials
- **AWS Provider** version ~> 5.0

### Installation

1. Clone the repository:
```bash
git clone <your-repo-url>
cd Terraform-wrappers-1
```

2. Initialize Terraform:
```bash
terraform init
```

3. Validate your configuration:
```bash
terraform validate
```

## 📖 Usage Guide

### Basic Usage Pattern

Each wrapper follows a consistent map-based configuration pattern. Here's an example with the EC2 wrapper:

```hcl
module "ec2" {
  source = "./wrappers/ec2-wrapper"
  
  instances = {
    web-server-1 = {
      name              = "web-server-1"
      ami               = "ami-0c55b159cbfafe1f0"
      instance_type     = "t3.medium"
      subnet_id         = "subnet-12345678"
      key_name          = "my-key-pair"
      security_groups   = ["sg-12345678"]
      root_volume_size  = 30
      root_volume_type  = "gp3"
      monitoring        = true
      tags = {
        Environment = "Production"
        Team        = "DevOps"
      }
    }
    
    web-server-2 = {
      name              = "web-server-2"
      ami               = "ami-0c55b159cbfafe1f0"
      instance_type     = "t3.medium"
      subnet_id         = "subnet-87654321"
      key_name          = "my-key-pair"
      security_groups   = ["sg-12345678"]
    }
  }
}
```

### VPC Wrapper Example

```hcl
module "vpc" {
  source = "./wrappers/vpc-wrapper"
  
  vpcs = {
    main-vpc = {
      name                 = "main-vpc"
      cidr_block           = "10.0.0.0/16"
      enable_dns_hostnames = true
      enable_dns_support   = true
      enable_nat_gateway   = true
      tags = {
        Environment = "Production"
      }
    }
  }
}
```

### S3 Wrapper Example

```hcl
module "s3" {
  source = "./wrappers/s3-wrapper"
  
  bucket_prefix = "my-app"
  force_destroy = false
  tags = {
    Environment = "Production"
    Purpose     = "Data Storage"
  }
}
```

### ALB Wrapper Example

```hcl
module "alb" {
  source = "./wrappers/alb-wrapper"
  
  albs = {
    web-alb = {
      name               = "web-alb"
      load_balancer_type = "application"
      internal           = false
      subnets            = ["subnet-12345678", "subnet-87654321"]
      security_groups    = ["sg-12345678"]
      enable_http2       = true
      tags = {
        Environment = "Production"
      }
    }
  }
}
```

## 📁 Directory Structure

```
Terraform-wrappers-1/
├── README.md                 # This file
├── versions.tf              # Provider versions and requirements
├── wrappers/
│   ├── alb-wrapper/        # Application Load Balancer
│   ├── cloudfront-wrapper/ # CloudFront CDN
│   ├── ec2-wrapper/        # EC2 Instances
│   ├── ecr-wrapper/        # Container Registry
│   ├── ecs-wrapper/        # Container Orchestration
│   ├── iam-wrapper/        # Identity & Access Management
│   ├── s3-wrapper/         # Object Storage
│   ├── sg-wrapper/         # Security Groups
│   └── vpc-wrapper/        # VPC & Networking
```

Each wrapper contains:
- `main.tf` - Resource definitions and logic
- `variables.tf` - Input variable definitions
- `outputs.tf` (optional) - Output values

## 🔧 Configuration

### Region Configuration

Edit the `aws_region` local variable in `versions.tf`:

```hcl
locals {
  aws_region = "ap-south-1"  # Change to your desired region
}
```

### AWS Provider Version

Modify the provider version in `versions.tf` if needed:

```hcl
terraform {
  required_providers {
    aws = {
        source  = "hashicorp/aws"
        version = "~> 5.0"  # Adjust version as needed
    }
  }
}
```

##  Best Practices

1. **Use Separate State Files** - Consider using remote state for production environments
2. **Organize Variables** - Create `terraform.tfvars` files for different environments
3. **Tag Resources** - Always include appropriate tags for cost allocation and organization
4. **Security Groups** - Use restrictive inbound rules and document outbound rules
5. **Monitoring** - Enable CloudWatch monitoring on production resources
6. **Backup S3 Buckets** - Enable versioning and MFA delete on sensitive buckets
7. **IAM Principles** - Follow the principle of least privilege when creating roles

## 📝 Common Workflows

### Deploy a Complete Stack

```bash
terraform plan -out=tfplan
terraform apply tfplan
```

### Destroy Resources

```bash
terraform destroy
```

### Update Specific Resources

```bash
terraform apply -target=module.ec2
```

## 🤝 Contributing

Contributions are welcome! Please ensure:

- Terraform code passes `terraform validate`
- Variables are well-documented
- Examples are provided in the README
- Security best practices are followed

##  License

See the [LICENSE](LICENSE) file for details.

##  Tips & Tricks

- **Parallel Deployment** - Multiple wrappers can be used together in the same configuration
- **Reusability** - Each wrapper can be called multiple times with different configurations
- **Flexible Sizing** - Optional parameters allow for both minimal and advanced configurations
- **Output Values** - Check each wrapper's `outputs.tf` for available output variables

##  Troubleshooting

| Issue | Solution |
|-------|----------|
| Provider version conflict | Update AWS provider: `terraform init -upgrade` |
| Invalid region error | Ensure region is valid in `versions.tf` |
| Permission denied | Verify AWS credentials are configured properly |
| State file issues | Use `terraform refresh` to sync state |

##  Additional Resources

- [AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest)
- [Terraform Official Docs](https://www.terraform.io/docs)
- [AWS Best Practices](https://aws.amazon.com/architecture/well-architected/)

---

**Last Updated**: April 2026  
**Project Status**: Active  
**Terraform Version**: >= 1.0  
**AWS Provider Version**: ~> 5.0
