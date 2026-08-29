# AWS上のZabbix 7.0監視ラボ（CloudFormation）

[![CloudFormation checks](https://github.com/ABFishyang/terraform-zbx-lab/actions/workflows/cloudformation.yml/badge.svg?branch=cloudformation)](https://github.com/ABFishyang/terraform-zbx-lab/actions/workflows/cloudformation.yml)

Amazon Linux 2023 上にZabbix 7.0の学習・検証環境を構築するCloudFormation版です。

テンプレートの構成、パラメータ、安全な検証手順、デプロイ方法については、[CloudFormation版の詳細README](cloudformation/README.md)を参照してください。

## 主な構成

- 2 AZ、Public Subnet 2つ、Private Subnet 2つ
- Zabbix Server 1台、Zabbix Agent 3台
- Session Managerによる管理（SSHポート22は未開放）
- 可選のNAT Gateway、CloudWatch Logs、SNS、メモリ・ディスクアラーム
- デフォルトではNAT Gateway、EC2、CloudWatch監視を作成しない安全設定

## クイック検証

```bash
cfn-lint cloudformation/templates/*.yaml
bash -n cloudformation/scripts/*.sh
```

## ライセンス

MIT License. See [LICENSE](LICENSE).
