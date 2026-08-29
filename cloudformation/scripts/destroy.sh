#!/usr/bin/env bash
set -euo pipefail

PROJECT="${PROJECT:-zbx-cfn-lab}"
REGION="${REGION:-ap-northeast-1}"

if ! command -v aws >/dev/null 2>&1; then
  echo "ERROR: AWS CLI v2 が必要です" >&2
  exit 1
fi

if ! aws cloudformation describe-stacks --region "$REGION" --stack-name "$PROJECT" >/dev/null 2>&1; then
  echo "スタック $PROJECT は存在しません。"
  exit 0
fi

read -r -p "スタック $PROJECT を削除しますか? [y/N] " answer
[[ "$answer" == "y" || "$answer" == "Y" ]] || { echo "中止しました。"; exit 0; }

aws cloudformation delete-stack --region "$REGION" --stack-name "$PROJECT"
aws cloudformation wait stack-delete-complete --region "$REGION" --stack-name "$PROJECT"
echo "削除が完了しました。"

