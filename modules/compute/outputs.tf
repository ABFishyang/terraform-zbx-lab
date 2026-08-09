output "ami_id" {
  description = "Resolved Amazon Linux 2023 AMI ID"
  value       = data.aws_ssm_parameter.al2023_ami.insecure_value
}

output "server_instance_id" {
  description = "Zabbix server instance ID, or null when disabled"
  value       = try(aws_instance.server[0].id, null)
}

output "server_private_ip" {
  description = "Zabbix server private IPv4 address, or null when disabled"
  value       = try(aws_instance.server[0].private_ip, null)
}

output "server_public_ip" {
  description = "Zabbix server public IPv4 address, or null when disabled"
  value       = try(aws_instance.server[0].public_ip, null)
}

output "agent_instance_ids" {
  description = "Map of monitored-host instance IDs"
  value       = { for key, instance in aws_instance.agent : key => instance.id }
}

output "agent_private_ips" {
  description = "Map of monitored-host private IPv4 addresses"
  value       = { for key, instance in aws_instance.agent : key => instance.private_ip }
}

output "agent_public_ips" {
  description = "Map of monitored-host public IPv4 addresses"
  value       = { for key, instance in aws_instance.agent : key => instance.public_ip }
}
