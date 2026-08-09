# security

Zabbix サーバー用とエージェント（監視対象ホスト）用の2つのセキュリティグループを作成する。

- サーバー: `admin_cidr` からのみ Web コンソール(80番)を許可
- サーバー ⇔ エージェント間は SGの相互参照で 10050/10051/ICMP を許可（CIDRではなくSG参照）
- 22番ポートは一切開放しない。管理は Systems Manager Session Manager 経由

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
| [aws_security_group.agent](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_vpc_security_group_egress_rule.agent_all_ipv4](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_egress_rule.server_all_ipv4](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.agent_icmp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.agent_passive](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.server_http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.server_trapper](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_admin_cidr"></a> [admin\_cidr](#input\_admin\_cidr) | Administrator public IPv4 address with /32 | `string` | n/a | yes |
| <a name="input_http_port"></a> [http\_port](#input\_http\_port) | HTTP port of the Zabbix web interface | `number` | `80` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Prefix used for resource names | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC | `string` | n/a | yes |
| <a name="input_zabbix_agent_port"></a> [zabbix\_agent\_port](#input\_zabbix\_agent\_port) | Zabbix agent passive-check port | `number` | `10050` | no |
| <a name="input_zabbix_server_port"></a> [zabbix\_server\_port](#input\_zabbix\_server\_port) | Zabbix trapper port | `number` | `10051` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_agent_security_group_id"></a> [agent\_security\_group\_id](#output\_agent\_security\_group\_id) | ID of the monitored-host security group |
| <a name="output_agent_security_group_name"></a> [agent\_security\_group\_name](#output\_agent\_security\_group\_name) | Name of the monitored-host security group |
| <a name="output_server_security_group_id"></a> [server\_security\_group\_id](#output\_server\_security\_group\_id) | ID of the Zabbix server security group |
| <a name="output_server_security_group_name"></a> [server\_security\_group\_name](#output\_server\_security\_group\_name) | Name of the Zabbix server security group |
<!-- END_TF_DOCS -->
