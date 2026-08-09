output "memory_alarm_name" {
  description = "Memory alarm name, or null when disabled"
  value       = try(aws_cloudwatch_metric_alarm.memory[0].alarm_name, null)
}

output "disk_alarm_name" {
  description = "Disk alarm name, or null when disabled"
  value       = try(aws_cloudwatch_metric_alarm.disk[0].alarm_name, null)
}
