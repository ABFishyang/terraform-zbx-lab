# AWS Zabbix Monitoring Lab

このリポジトリでは、AWS上にZabbix 7.0の学習・検証環境を構築する2つのInfrastructure as Code実装を公開しています。

## 実装を選択

| バージョン | ブランチ | 概要 |
| --- | --- | --- |
| Terraform | [`terraform`](https://github.com/ABFishyang/terraform-zbx-lab/tree/terraform) | Terraformモジュール、変数、検証ワークフローを含む実装 |
| CloudFormation | [`cloudformation`](https://github.com/ABFishyang/terraform-zbx-lab/tree/cloudformation) | CloudFormationテンプレート、パラメータ、デプロイスクリプトを含む実装 |

各ブランチは独立した実装です。利用するバージョンのブランチを選択し、そのREADMEに従って検証・デプロイしてください。

## ライセンス

MIT License. See [LICENSE](LICENSE).
