output "vpc_id" {
  description = "ID of the VPC"
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "Map of public subnet IDs"
  value       = module.network.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Map of private subnet IDs"
  value       = module.network.private_subnet_ids
}

output "public_route_table_id" {
  description = "ID of the public route table"
  value       = module.network.public_route_table_id
}

output "private_route_table_ids" {
  description = "Map of private route table IDs"
  value       = module.network.private_route_table_ids
}

output "nat_gateway_id" {
  description = "NAT Gateway ID, or null when disabled"
  value       = module.network.nat_gateway_id
}

output "server_security_group_id" {
  description = "ID of the Zabbix server security group"
  value       = module.security.server_security_group_id
}

output "agent_security_group_id" {
  description = "ID of the monitored-host security group"
  value       = module.security.agent_security_group_id
}

output "iam_role_name" {
  description = "Name of the EC2 IAM role"
  value       = module.iam.role_name
}

output "instance_profile_name" {
  description = "Name of the EC2 instance profile"
  value       = module.iam.instance_profile_name
}

output "ami_id" {
  description = "Resolved Amazon Linux 2023 AMI ID"
  value       = module.compute.ami_id
}

output "server_instance_id" {
  description = "Zabbix server instance ID, or null when disabled"
  value       = module.compute.server_instance_id
}

output "server_private_ip" {
  description = "Zabbix server private IPv4 address, or null when disabled"
  value       = module.compute.server_private_ip
}

output "server_public_ip" {
  description = "Zabbix server public IPv4 address, or null when disabled"
  value       = module.compute.server_public_ip
}

output "zabbix_web_url" {
  description = "URL of the Zabbix web interface, or null when disabled"
  value       = module.compute.server_public_ip == null ? null : "http://${module.compute.server_public_ip}/zabbix"
}

output "agent_instance_ids" {
  description = "Map of monitored-host instance IDs"
  value       = module.compute.agent_instance_ids
}

output "agent_private_ips" {
  description = "Map of monitored-host private IPv4 addresses"
  value       = module.compute.agent_private_ips
}

output "agent_public_ips" {
  description = "Map of monitored-host public IPv4 addresses"
  value       = module.compute.agent_public_ips
}

output "cloudwatch_log_group_names" {
  description = "Map of CloudWatch log group names"
  value       = module.monitoring.log_group_names
}

output "sns_topic_arn" {
  description = "SNS alert topic ARN, or null when disabled"
  value       = module.monitoring.sns_topic_arn
}

output "memory_alarm_name" {
  description = "Name of the memory usage alarm, or null when disabled"
  value       = module.alarms.memory_alarm_name
}

output "disk_alarm_name" {
  description = "Name of the disk usage alarm, or null when disabled"
  value       = module.alarms.disk_alarm_name
}
