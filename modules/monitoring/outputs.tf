output "log_group_names" {
  description = "Map of CloudWatch log group names"
  value       = { for key, group in aws_cloudwatch_log_group.main : key => group.name }
}

output "sns_topic_arn" {
  description = "SNS alert topic ARN, or null when disabled"
  value       = try(aws_sns_topic.alerts[0].arn, null)
}
