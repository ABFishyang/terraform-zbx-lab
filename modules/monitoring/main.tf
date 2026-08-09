locals {
  log_groups = {
    httpd_access  = "/${var.project_name}/zabbix-server/httpd/access"
    httpd_error   = "/${var.project_name}/zabbix-server/httpd/error"
    zabbix_server = "/${var.project_name}/zabbix-server/zabbix/server"
  }
}

resource "aws_cloudwatch_log_group" "main" {
  for_each = var.enable_monitoring ? local.log_groups : {}

  name              = each.value
  retention_in_days = var.log_retention_days

  tags = {
    Name = each.value
  }
}

resource "aws_sns_topic" "alerts" {
  count = var.enable_monitoring ? 1 : 0

  name = "${var.project_name}-alerts"

  tags = {
    Name = "${var.project_name}-alerts"
  }
}

resource "aws_sns_topic_subscription" "email" {
  count = var.enable_monitoring && var.alarm_email != null ? 1 : 0

  topic_arn = aws_sns_topic.alerts[0].arn
  protocol  = "email"
  endpoint  = var.alarm_email
}
