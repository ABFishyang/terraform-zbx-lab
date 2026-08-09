# alarms

Zabbix サーバーのメモリ使用率・ルートディスク使用率に対する CloudWatch アラームを作成する（`CWAgent` 名前空間のカスタムメトリクスを使用）。

- `evaluation_periods` / `datapoints_to_alarm` を分けているため、単発のスパイクでは発報せず、継続した閾値超過のみ検知する構成

<!-- BEGIN_TF_DOCS -->


## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10.0, < 2.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 6.0 |

## Resources

| Name | Type |
| ---- | ---- |
| [aws_cloudwatch_metric_alarm.disk](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.memory](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_alarm_period_seconds"></a> [alarm\_period\_seconds](#input\_alarm\_period\_seconds) | CloudWatch alarm period in seconds | `number` | n/a | yes |
| <a name="input_datapoints_to_alarm"></a> [datapoints\_to\_alarm](#input\_datapoints\_to\_alarm) | Number of breaching periods required to enter ALARM state | `number` | n/a | yes |
| <a name="input_disk_alarm_threshold"></a> [disk\_alarm\_threshold](#input\_disk\_alarm\_threshold) | Root disk usage alarm threshold in percent | `number` | n/a | yes |
| <a name="input_enable_monitoring"></a> [enable\_monitoring](#input\_enable\_monitoring) | Create CloudWatch alarms | `bool` | n/a | yes |
| <a name="input_evaluation_periods"></a> [evaluation\_periods](#input\_evaluation\_periods) | Number of periods evaluated by CloudWatch alarms | `number` | n/a | yes |
| <a name="input_memory_alarm_threshold"></a> [memory\_alarm\_threshold](#input\_memory\_alarm\_threshold) | Memory usage alarm threshold in percent | `number` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Prefix used for resource names | `string` | n/a | yes |
| <a name="input_server_instance_id"></a> [server\_instance\_id](#input\_server\_instance\_id) | Instance ID of the Zabbix server | `string` | `null` | no |
| <a name="input_sns_topic_arn"></a> [sns\_topic\_arn](#input\_sns\_topic\_arn) | SNS topic ARN used by alarm actions | `string` | `null` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_disk_alarm_name"></a> [disk\_alarm\_name](#output\_disk\_alarm\_name) | Disk alarm name, or null when disabled |
| <a name="output_memory_alarm_name"></a> [memory\_alarm\_name](#output\_memory\_alarm\_name) | Memory alarm name, or null when disabled |
<!-- END_TF_DOCS -->
