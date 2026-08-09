variable "aws_region" {
  description = "AWS region used by this project"
  type        = string
  default     = "ap-northeast-1"
}

variable "project_name" {
  description = "Prefix used for resource names and tags"
  type        = string
  default     = "zbx-tf-lab"

  validation {
    condition     = can(regex("^[a-z0-9-]{3,24}$", var.project_name))
    error_message = "project_name must contain 3-24 lowercase letters, numbers, or hyphens."
  }
}

variable "vpc_cidr" {
  description = "IPv4 CIDR of the VPC"
  type        = string
  default     = "10.1.0.0/16"
}

variable "availability_zones" {
  description = "Two availability zones used by the lab"
  type        = list(string)
  default     = ["ap-northeast-1a", "ap-northeast-1c"]

  validation {
    condition     = length(var.availability_zones) == 2
    error_message = "Exactly two availability zones are required."
  }
}

variable "public_subnet_cidrs" {
  description = "CIDRs of public-a and public-b"
  type        = list(string)
  default     = ["10.1.0.0/24", "10.1.2.0/24"]

  validation {
    condition     = length(var.public_subnet_cidrs) == 2
    error_message = "Exactly two public subnet CIDRs are required."
  }
}

variable "private_subnet_cidrs" {
  description = "CIDRs of private-a and private-b"
  type        = list(string)
  default     = ["10.1.1.0/24", "10.1.3.0/24"]

  validation {
    condition     = length(var.private_subnet_cidrs) == 2
    error_message = "Exactly two private subnet CIDRs are required."
  }
}

variable "admin_cidr" {
  description = "Administrator public IPv4 address in CIDR notation, for example 203.0.113.10/32"
  type        = string

  validation {
    condition     = can(cidrhost(var.admin_cidr, 0)) && can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}/32$", var.admin_cidr))
    error_message = "admin_cidr must be one IPv4 address with /32."
  }
}

variable "enable_nat_gateway" {
  description = "Create one NAT Gateway and an Elastic IP. This incurs hourly and data charges."
  type        = bool
  default     = false
}

variable "create_ec2_instances" {
  description = "Create the Zabbix server and three monitored EC2 instances"
  type        = bool
  default     = false
}

variable "enable_monitoring" {
  description = "Create CloudWatch log groups, alarms, and an SNS topic"
  type        = bool
  default     = false
}

variable "server_instance_type" {
  description = "EC2 instance type of the Zabbix server"
  type        = string
  default     = "t3.small"
}

variable "agent_instance_type" {
  description = "EC2 instance type of each monitored host"
  type        = string
  default     = "t3.micro"
}

variable "server_root_volume_size" {
  description = "Root volume size of the Zabbix server in GiB"
  type        = number
  default     = 20
}

variable "agent_root_volume_size" {
  description = "Root volume size of each monitored host in GiB"
  type        = number
  default     = 8
}

variable "enable_detailed_monitoring" {
  description = "Enable EC2 one-minute detailed monitoring, which incurs charges"
  type        = bool
  default     = false
}

variable "server_private_ip" {
  description = "Private IPv4 address of the Zabbix server"
  type        = string
  default     = "10.1.0.10"
}

variable "agent_private_ips" {
  description = "Private IPv4 addresses of the monitored hosts"
  type        = map(string)
  default = {
    public-b  = "10.1.2.10"
    private-a = "10.1.1.10"
    private-b = "10.1.3.10"
  }

  validation {
    condition = setequals(
      toset(keys(var.agent_private_ips)),
      toset(["public-b", "private-a", "private-b"])
    )
    error_message = "agent_private_ips must contain public-b, private-a, and private-b."
  }
}

variable "zabbix_db_password" {
  description = "Password used by the local Zabbix MariaDB account"
  type        = string
  sensitive   = true

  validation {
    condition     = can(regex("^[A-Za-z0-9_@#%+=.-]{8,64}$", var.zabbix_db_password))
    error_message = "The database password must contain 8-64 permitted characters."
  }
}

variable "alarm_email" {
  description = "Optional email address subscribed to the SNS alarm topic"
  type        = string
  default     = null
  nullable    = true

  validation {
    condition     = var.alarm_email == null || can(regex("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$", var.alarm_email))
    error_message = "alarm_email must be null or a valid email address."
  }
}

variable "memory_alarm_threshold" {
  description = "Memory usage alarm threshold in percent"
  type        = number
  default     = 80
}

variable "disk_alarm_threshold" {
  description = "Root disk usage alarm threshold in percent"
  type        = number
  default     = 80
}

variable "alarm_period_seconds" {
  description = "CloudWatch alarm period in seconds"
  type        = number
  default     = 60
}

variable "evaluation_periods" {
  description = "Number of periods evaluated by CloudWatch alarms"
  type        = number
  default     = 5
}

variable "datapoints_to_alarm" {
  description = "Number of breaching periods required to enter ALARM state"
  type        = number
  default     = 5
}

variable "log_retention_days" {
  description = "CloudWatch Logs retention period"
  type        = number
  default     = 7
}
