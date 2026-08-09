variable "project_name" {
  description = "Prefix used for resource names"
  type        = string
}

variable "enable_monitoring" {
  description = "Create CloudWatch alarms"
  type        = bool
}

variable "server_instance_id" {
  description = "Instance ID of the Zabbix server"
  type        = string
  default     = null
  nullable    = true
}

variable "sns_topic_arn" {
  description = "SNS topic ARN used by alarm actions"
  type        = string
  default     = null
  nullable    = true
}

variable "memory_alarm_threshold" {
  description = "Memory usage alarm threshold in percent"
  type        = number
}

variable "disk_alarm_threshold" {
  description = "Root disk usage alarm threshold in percent"
  type        = number
}

variable "alarm_period_seconds" {
  description = "CloudWatch alarm period in seconds"
  type        = number
}

variable "evaluation_periods" {
  description = "Number of periods evaluated by CloudWatch alarms"
  type        = number
}

variable "datapoints_to_alarm" {
  description = "Number of breaching periods required to enter ALARM state"
  type        = number
}
