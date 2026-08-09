resource "aws_cloudwatch_metric_alarm" "memory" {
  count = var.enable_monitoring ? 1 : 0

  alarm_name          = "${var.project_name}-server-memory-high"
  alarm_description   = "Zabbix server memory usage is above the configured threshold"
  namespace           = "CWAgent"
  metric_name         = "mem_used_percent"
  statistic           = "Average"
  period              = var.alarm_period_seconds
  evaluation_periods  = var.evaluation_periods
  datapoints_to_alarm = var.datapoints_to_alarm
  threshold           = var.memory_alarm_threshold
  comparison_operator = "GreaterThanOrEqualToThreshold"
  treat_missing_data  = "missing"
  alarm_actions       = [var.sns_topic_arn]
  ok_actions          = [var.sns_topic_arn]

  dimensions = {
    InstanceId = var.server_instance_id
  }

  tags = {
    Name = "${var.project_name}-server-memory-high"
  }
}

resource "aws_cloudwatch_metric_alarm" "disk" {
  count = var.enable_monitoring ? 1 : 0

  alarm_name          = "${var.project_name}-server-root-disk-high"
  alarm_description   = "Zabbix server root disk usage is above the configured threshold"
  namespace           = "CWAgent"
  metric_name         = "disk_used_percent"
  statistic           = "Average"
  period              = var.alarm_period_seconds
  evaluation_periods  = var.evaluation_periods
  datapoints_to_alarm = var.datapoints_to_alarm
  threshold           = var.disk_alarm_threshold
  comparison_operator = "GreaterThanOrEqualToThreshold"
  treat_missing_data  = "missing"
  alarm_actions       = [var.sns_topic_arn]
  ok_actions          = [var.sns_topic_arn]

  dimensions = {
    InstanceId = var.server_instance_id
    path       = "/"
    fstype     = "xfs"
  }

  tags = {
    Name = "${var.project_name}-server-root-disk-high"
  }
}
