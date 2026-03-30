variable "alb_tg1_name" {
  description = "1st target group name"
  type        = string
}

variable "alb_tg2_name" {
  description = "2nd target group name"
  type        = string
}

variable "vpc_id" {
  description = "vpc id for tg"
  type        = string
}
