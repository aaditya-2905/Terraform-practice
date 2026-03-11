variable "bucket_names_set" {
  description = "Names of the buckets"
  type        = set(string)
  default     = ["pr-bucket-set-1", "pr-bucket-set-2"]
}

variable "bucket_names_list" {
  description = "Names of the buckets"
  type        = list(string)
  default     = ["pr-bucket-list-1", "pr-bucket-list-2"]
}

variable "vpc_id" {
  description = "Vpc id"
  default = "vpc-0cf6c7c27dd9ab0d9"
}