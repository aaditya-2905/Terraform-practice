variable "aws_region" {
  type = string
}

variable "ecr_image_url" {
  type = string
}

variable "alb_target_group_arn" {
  type = string
}

variable "pvt_subnet_ids" {
  type = list(string)
}

variable "sg_id" {
  type = list(string)
}

variable "db_cluster_endpoint" {
  type = string
}

variable "db_secret_arn" {
  type = string
}
