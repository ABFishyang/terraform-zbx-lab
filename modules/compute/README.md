# compute

Zabbix サーバー（1台）と、監視対象ホスト（`public-b` / `private-a` / `private-b` の3台）の EC2 インスタンスを作成する。

- AMI は SSM パブリックパラメータから Amazon Linux 2023 の最新版を解決
- `create_instances = false`（既定）の場合、インスタンスは一切作成されない
- User Data は `templatefile()` でレンダリングされたブートストラップスクリプト（呼び出し元の `main.tf` を参照）

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
| [aws_instance.agent](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_instance.server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_ssm_parameter.al2023_ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_agent_instance_type"></a> [agent\_instance\_type](#input\_agent\_instance\_type) | Instance type of each monitored host | `string` | n/a | yes |
| <a name="input_agent_private_ips"></a> [agent\_private\_ips](#input\_agent\_private\_ips) | Private IPv4 addresses of monitored hosts | `map(string)` | n/a | yes |
| <a name="input_agent_root_volume_size"></a> [agent\_root\_volume\_size](#input\_agent\_root\_volume\_size) | Root volume size of each monitored host in GiB | `number` | n/a | yes |
| <a name="input_agent_security_group_id"></a> [agent\_security\_group\_id](#input\_agent\_security\_group\_id) | Security group ID of the monitored hosts | `string` | n/a | yes |
| <a name="input_agent_user_data"></a> [agent\_user\_data](#input\_agent\_user\_data) | Rendered bootstrap scripts for monitored hosts | `map(string)` | n/a | yes |
| <a name="input_create_instances"></a> [create\_instances](#input\_create\_instances) | Create the Zabbix server and monitored hosts | `bool` | n/a | yes |
| <a name="input_enable_detailed_monitoring"></a> [enable\_detailed\_monitoring](#input\_enable\_detailed\_monitoring) | Enable EC2 one-minute detailed monitoring | `bool` | n/a | yes |
| <a name="input_iam_instance_profile_name"></a> [iam\_instance\_profile\_name](#input\_iam\_instance\_profile\_name) | Name of the IAM instance profile | `string` | n/a | yes |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | Map containing private subnet IDs a and b | `map(string)` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Prefix used for resource names | `string` | n/a | yes |
| <a name="input_public_subnet_ids"></a> [public\_subnet\_ids](#input\_public\_subnet\_ids) | Map containing public subnet IDs a and b | `map(string)` | n/a | yes |
| <a name="input_server_instance_type"></a> [server\_instance\_type](#input\_server\_instance\_type) | Instance type of the Zabbix server | `string` | n/a | yes |
| <a name="input_server_private_ip"></a> [server\_private\_ip](#input\_server\_private\_ip) | Private IPv4 address of the Zabbix server | `string` | n/a | yes |
| <a name="input_server_root_volume_size"></a> [server\_root\_volume\_size](#input\_server\_root\_volume\_size) | Root volume size of the Zabbix server in GiB | `number` | n/a | yes |
| <a name="input_server_security_group_id"></a> [server\_security\_group\_id](#input\_server\_security\_group\_id) | Security group ID of the Zabbix server | `string` | n/a | yes |
| <a name="input_server_user_data"></a> [server\_user\_data](#input\_server\_user\_data) | Rendered bootstrap script for the Zabbix server | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_agent_instance_ids"></a> [agent\_instance\_ids](#output\_agent\_instance\_ids) | Map of monitored-host instance IDs |
| <a name="output_agent_private_ips"></a> [agent\_private\_ips](#output\_agent\_private\_ips) | Map of monitored-host private IPv4 addresses |
| <a name="output_agent_public_ips"></a> [agent\_public\_ips](#output\_agent\_public\_ips) | Map of monitored-host public IPv4 addresses |
| <a name="output_ami_id"></a> [ami\_id](#output\_ami\_id) | Resolved Amazon Linux 2023 AMI ID |
| <a name="output_server_instance_id"></a> [server\_instance\_id](#output\_server\_instance\_id) | Zabbix server instance ID, or null when disabled |
| <a name="output_server_private_ip"></a> [server\_private\_ip](#output\_server\_private\_ip) | Zabbix server private IPv4 address, or null when disabled |
| <a name="output_server_public_ip"></a> [server\_public\_ip](#output\_server\_public\_ip) | Zabbix server public IPv4 address, or null when disabled |
<!-- END_TF_DOCS -->
