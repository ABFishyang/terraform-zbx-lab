variable "project_name" {
  description = "Prefix used for resource names"
  type        = string
}

variable "enable_monitoring" {
  description = "Create CloudWatch monitoring resources"
  type        = bool
}

variable "alarm_email" {
  description = "Optional email address subscribed to the SNS alert topic"
  type        = string
  default     = null
  nullable    = true
}

variable "log_retention_days" {
  description = "CloudWatch Logs retention period"
  type        = number
}
