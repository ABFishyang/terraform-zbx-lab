variable "project_name" {
  description = "Prefix used for resource names"
  type        = string
}

variable "create_instances" {
  description = "Create the Zabbix server and monitored hosts"
  type        = bool
}

variable "public_subnet_ids" {
  description = "Map containing public subnet IDs a and b"
  type        = map(string)
}

variable "private_subnet_ids" {
  description = "Map containing private subnet IDs a and b"
  type        = map(string)
}

variable "server_security_group_id" {
  description = "Security group ID of the Zabbix server"
  type        = string
}

variable "agent_security_group_id" {
  description = "Security group ID of the monitored hosts"
  type        = string
}

variable "iam_instance_profile_name" {
  description = "Name of the IAM instance profile"
  type        = string
}

variable "server_instance_type" {
  description = "Instance type of the Zabbix server"
  type        = string
}

variable "agent_instance_type" {
  description = "Instance type of each monitored host"
  type        = string
}

variable "server_root_volume_size" {
  description = "Root volume size of the Zabbix server in GiB"
  type        = number
}

variable "agent_root_volume_size" {
  description = "Root volume size of each monitored host in GiB"
  type        = number
}

variable "enable_detailed_monitoring" {
  description = "Enable EC2 one-minute detailed monitoring"
  type        = bool
}

variable "server_private_ip" {
  description = "Private IPv4 address of the Zabbix server"
  type        = string
}

variable "agent_private_ips" {
  description = "Private IPv4 addresses of monitored hosts"
  type        = map(string)
}

variable "server_user_data" {
  description = "Rendered bootstrap script for the Zabbix server"
  type        = string
  sensitive   = true
}

variable "agent_user_data" {
  description = "Rendered bootstrap scripts for monitored hosts"
  type        = map(string)
  sensitive   = true
}
