variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "vpc_tags" {
  type = map(string)
  default = {
    "name" = "production"
  }
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "sg_ingress_rule" {

  type = map(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))

  default = {
    ssh = {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "SSH access"
    }

    http = {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTP access"
    }

    https = {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTPS access"
    }
  }
}

variable "sg_egress_rule" {

  type = map(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))

  default = {
    all = {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound"
    }
  }
}

variable "alb_name" {
  description = "alb name"
  default     = "project1-alb"
}

variable "s3_bucket_name" {
  description = "bucket name"
  default     = "project1-s3-bucket-tf"
}

variable "s3_environment" {
  default = "project1"
}

variable "iam_role1_name" {
  description = "Name of the IAM role for ECS task execution"
  default     = "project1-ecs-task-execution-role"
}

variable "iam_role2_name" {
  description = "Name of the IAM role for codedeploy"
  default     = "project1-codedeploy-role"
}

variable "alb_tg1_name" {
  description = "1st target group name"
  default     = "blue-tg"
}

variable "alb_tg2_name" {
  description = "2nd target group name"
  default     = "green-tg"
}

variable "ecr_repo" {
  description = "Name of ecr repo"
  default     = "project1-ecr-repo"
}

variable "ecs_cluster_name" {
  description = "name for ecs cluster"
  default = "project1-ecs-cluster"
}

variable "ecs_task_family" {
  description = "value for task family"
  default = "project1-ecs-task-family"
}

variable "ecs_desired_count" {
  description = "desired count for ecs service"
  default = 1
}

variable "codedeploy_app_name" {
  description = "name for the deploy app"
  default = "project1-codedeploy-app"
}

