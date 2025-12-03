variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "allowed_cidrs" {
  description = "CIDR blocks allowed to access Postgres"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "eks_security_group_id" {
  description = "Optional EKS security group ID that should be allowed to connect to RDS"
  type        = string
  default     = ""
}

variable "postgres_engine_version" {
  description = "Postgres engine version"
  type        = string
  default     = "17.6"
}

variable "initial_db_name" {
  description = "Initial database name"
  type        = string
  default     = "db_mecanica_xpto"
}

variable "postgres_username" {
  description = "Master Postgres username"
  type        = string
  default     = "admin_user"
}

variable "postgres_password" {
  description = "Master Postgres password"
  type        = string
  sensitive   = true
  # NOTE: The provided value U2VuaGExMjM= looks base64; using as-is per request.
  default     = "U2VuaGExMjM="
}
