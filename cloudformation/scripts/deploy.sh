#!/usr/bin/env bash
set -euo pipefail

PROJECT="${PROJECT:-zbx-cfn-lab}"
REGION="${REGION:-ap-northeast-1}"
ADMIN_CIDR="${ADMIN_CIDR:-}"
DB_PASSWORD="${DB_PASSWORD:-}"
ENABLE_NAT_GATEWAY="${ENABLE_NAT_GATEWAY:-false}"
CREATE_EC2_INSTANCES="${CREATE_EC2_INSTANCES:-false}"
ENABLE_MONITORING="${ENABLE_MONITORING:-false}"
ALARM_EMAIL="${ALARM_EMAIL:-}"

if ! command -v aws >/dev/null 2>&1; then
  echo "ERROR: AWS CLI v2 が必要です" >&2
  exit 1
fi

if [[ -z "$ADMIN_CIDR" ]]; then
  echo "ERROR: ADMIN_CIDR を /32 形式で設定してください" >&2
  exit 1
fi

if [[ -z "$DB_PASSWORD" ]]; then
  echo "ERROR: DB_PASSWORD を設定してください" >&2
  exit 1
fi

if [[ "$CREATE_EC2_INSTANCES" == "true" && "$ENABLE_NAT_GATEWAY" != "true" ]]; then
  echo "ERROR: EC2 を作成する場合は ENABLE_NAT_GATEWAY=true が必要です" >&2
  exit 1
fi

if [[ "$ENABLE_MONITORING" == "true" && "$CREATE_EC2_INSTANCES" != "true" ]]; then
  echo "ERROR: 監視を有効にする場合は CREATE_EC2_INSTANCES=true が必要です" >&2
  exit 1
fi

cd "$(dirname "$0")/.."

aws cloudformation deploy \
  --region "$REGION" \
  --stack-name "$PROJECT" \
  --template-file templates/zabbix-lab.yaml \
  --capabilities CAPABILITY_NAMED_IAM \
  --no-fail-on-empty-changeset \
  --parameter-overrides \
    "ProjectName=$PROJECT" \
    "AdminCidr=$ADMIN_CIDR" \
    "ZabbixDbPassword=$DB_PASSWORD" \
    "EnableNatGateway=$ENABLE_NAT_GATEWAY" \
    "CreateEc2Instances=$CREATE_EC2_INSTANCES" \
    "EnableMonitoring=$ENABLE_MONITORING" \
    "AlarmEmail=$ALARM_EMAIL"

aws cloudformation describe-stacks \
  --region "$REGION" \
  --stack-name "$PROJECT" \
  --query 'Stacks[0].Outputs' \
  --output table

if [[ -n "$ALARM_EMAIL" && "$ENABLE_MONITORING" == "true" ]]; then
  echo "SNS の購読確認メールを承認してください。"
fi

