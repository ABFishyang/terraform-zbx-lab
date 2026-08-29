# AWS上のZabbix 7.0監視ラボ（CloudFormation）

Amazon Linux 2023 上に Zabbix 7.0 の学習・検証環境を構築する CloudFormation 実装です。Terraform 版と同じく、VPC、4つのサブネット、セキュリティグループ、IAM、Zabbix Server 1台、Agent 3台、CloudWatch Logs、SNS、メモリ・ディスクアラームを構成します。

> デフォルトでは NAT Gateway、EC2、CloudWatch 監視リソースを作成しません。料金が発生する設定は、内容を確認してから明示的に有効化してください。

## 検証状況

| 確認項目 | 状態 |
| --- | --- |
| YAML構文 | 確認済み |
| `cfn-lint` | CIで確認 |
| シェル構文 | CIで確認 |
| Change Set / デプロイ | 未実施 |
| Zabbix動作確認 | 未実施 |

## 構成

- 2 AZ、Public Subnet 2つ、Private Subnet 2つ
- Public-a: Zabbix Server
- Public-b: Zabbix Agent
- Private-a / Private-b: Zabbix Agent
- 管理者からZabbix WebへのHTTP 80は `AdminCidr` のみ許可
- ServerからAgentへのTCP 10050とICMPを許可
- AgentからServerへのTCP 10051を許可
- SSHは開放せず、Session Managerを使用
- CloudWatch Logs、SNS、メモリ・ルートディスクアラームは任意

## ディレクトリ構成

```text
cloudformation/
├── README.md
├── parameters/
│   └── example.json
├── scripts/
│   ├── deploy.sh
│   └── destroy.sh
└── templates/
    └── zabbix-lab.yaml
```

## 前提条件

- AWS CLI v2
- CloudFormation、VPC、EC2、IAM、CloudWatch、SNSを操作できるAWS権限
- AWS CLI認証情報をリポジトリ外で設定済みであること

## 安全な初期確認

`parameters/example.json` の初期値は次の状態です。

```text
EnableNatGateway=false
CreateEc2Instances=false
EnableMonitoring=false
```

この設定ではネットワーク、セキュリティグループ、IAMのみを作成します。まずテンプレートを検証してください。

```bash
aws cloudformation validate-template \
  --region ap-northeast-1 \
  --template-body file://cloudformation/templates/zabbix-lab.yaml
```

## デプロイ

デプロイスクリプトはデータベースパスワードをファイルへ保存せず、環境変数からCloudFormationのNoEchoパラメータへ渡します。

```bash
export REGION=ap-northeast-1
export PROJECT=zbx-cfn-lab
export ADMIN_CIDR=203.0.113.10/32
export DB_PASSWORD='CHANGE_ME_123'

# ネットワーク、SG、IAMのみ
bash cloudformation/scripts/deploy.sh
```

EC2を含むラボ全体を作成する場合、Private Subnet上のAgentが初期パッケージを取得できるようNAT Gatewayも有効化します。

```bash
export ENABLE_NAT_GATEWAY=true
export CREATE_EC2_INSTANCES=true
export ENABLE_MONITORING=true
export ALARM_EMAIL=you@example.com
bash cloudformation/scripts/deploy.sh
```

デプロイ後、SNSから届く購読確認メールを承認してください。Zabbix WebのURLはスタック出力 `ZabbixWebUrl` で確認できます。

## 接続

```bash
aws ssm start-session --region "$REGION" --target <instance-id>
```

## 削除

```bash
bash cloudformation/scripts/destroy.sh
```

## 注意事項

- HTTP通信を使用する学習用構成です。本番環境ではALB、HTTPS、外部DB、バックアップ、冗長化を検討してください。
- ZabbixのローカルMariaDBパスワードはEC2 UserDataに渡されます。本番用途ではSecrets Managerなどへ変更してください。
- NAT Gateway、EC2、詳細モニタリング、CloudWatch Logsには料金が発生する可能性があります。

