 
variable "env" {
  type        = string
  description = "Environment tag for the ECS service"
}

variable "cluster_name" {
  type        = string
  description = "Name of the ECS cluster"
}

variable "task_family" {
  type        = string
  description = "Family name of the ECS task"
}

variable "container_definitions" {
  type        = string
  description = "Container definitions in JSON format"
}

variable "container_memory" {
  type        = number
  description = "Memory for the container"
}

variable "container_cpu" {
  type        = number
  description = "CPU units for the container"
}

variable "service_name" {
  type        = string
  description = "Name of the ECS service"
}

variable "desired_count" {
  type        = number
  description = "Number of desired containers for the service"
}
variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs where the ECS Fargate tasks will be deployed."
  
} 

