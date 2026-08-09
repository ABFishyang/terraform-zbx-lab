output "server_security_group_id" {
  description = "ID of the Zabbix server security group"
  value       = aws_security_group.server.id
}

output "agent_security_group_id" {
  description = "ID of the monitored-host security group"
  value       = aws_security_group.agent.id
}

output "server_security_group_name" {
  description = "Name of the Zabbix server security group"
  value       = aws_security_group.server.name
}

output "agent_security_group_name" {
  description = "Name of the monitored-host security group"
  value       = aws_security_group.agent.name
}
