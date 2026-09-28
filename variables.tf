variable "region" {
  description = "AWS region to deploy into."
  type        = string
  default     = "us-east-1"
}

variable "name" {
  description = "Name for the instance and related resources."
  type        = string
  default     = "app-server"
}

variable "vpc_id" {
  description = "VPC to deploy into."
  type        = string
}

variable "subnet_id" {
  description = "Subnet for the instance. Use a public subnet if associate_public_ip is true."
  type        = string
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to reach the app_port."
  type        = list(string)

  validation {
    condition     = length(var.allowed_cidr_blocks) > 0 && !contains(var.allowed_cidr_blocks, "0.0.0.0/0")
    error_message = "Provide at least one CIDR block, and do not open the instance to 0.0.0.0/0."
  }
}

variable "app_port" {
  description = "Port the application (started by the user data script) listens on."
  type        = number
  default     = 8080
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "root_volume_size_gb" {
  description = "Size of the encrypted root volume in GiB."
  type        = number
  default     = 20
}

variable "associate_public_ip" {
  description = "Whether to assign a public IP address to the instance."
  type        = bool
  default     = true
}

variable "packages" {
  description = "Extra dnf packages to install via user data, beyond the base set the script always installs."
  type        = list(string)
  default     = []
}

variable "app_user_data" {
  description = "Extra shell commands appended to the generated user data script, e.g. to pull and start your application. Runs after Docker and CloudWatch Agent are installed and after IAM/SSM are ready."
  type        = string
  default     = "# no extra app bootstrap supplied -- see variables.tf: app_user_data"
}

variable "enable_detailed_monitoring" {
  description = "Enable EC2 detailed (1-minute) CloudWatch monitoring."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Additional tags applied to all resources."
  type        = map(string)
  default     = {}
}
