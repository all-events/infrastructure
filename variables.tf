variable "ecs_cluster_name" {
  description = "The name given to the ECS cluster"
  type        = string
  default     = "allevents-dev-cluster"
}

variable "vpc_cidr_block" {
  description = "The CIDR block to be assigned to the VPC where resources will be deployed"
  type        = string
  default     = "10.2.0.0/16"
}

variable "github_token" {
  description = "GitHub personal token"
  type        = string
  default     = ""
}