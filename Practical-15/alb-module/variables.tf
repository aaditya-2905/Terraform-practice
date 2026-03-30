variable "alb_name" {
  description = "alb name"
  type        = string
}

variable "alb_subnet" {
  description = "subnet value for alb"
  type        = list(string)
}

variable "sg_for_alb" {
  description = "sg's of alb"
  type        = list(string)
}

variable "s3_bucket_name" {
  description = "name of sg"
  type        = string
}

variable "alb_tg1_arn" {
  type = string
}

variable "alb_tg2_arn" {
  type = string
}