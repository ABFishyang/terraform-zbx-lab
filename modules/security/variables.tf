variable "project_name" {
  description = "Prefix used for resource names"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "admin_cidr" {
  description = "Administrator public IPv4 address with /32"
  type        = string
}

variable "http_port" {
  description = "HTTP port of the Zabbix web interface"
  type        = number
  default     = 80
}

variable "zabbix_server_port" {
  description = "Zabbix trapper port"
  type        = number
  default     = 10051
}

variable "zabbix_agent_port" {
  description = "Zabbix agent passive-check port"
  type        = number
  default     = 10050
}
