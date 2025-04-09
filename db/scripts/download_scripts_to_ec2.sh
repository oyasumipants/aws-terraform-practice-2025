#!/bin/bash

set -e

ENV=${1:-techXX}

BUCKET_NAME="${ENV}-operation-scripts"

INSTANCE_ID=$(aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=${ENV}-operation-instance" "Name=instance-state-name,Values=running" \
  --query "Reservations[0].Instances[0].InstanceId" \
  --output text)

run_ssm_command() {
  local cmd="$1"
  aws ssm send-command \
    --instance-ids "$INSTANCE_ID" \
    --document-name "AWS-RunShellScript" \
    --parameters "commands=['$cmd']" \
    --comment "Execute command from download_scripts_to_ec2.sh" \
    --output text > /dev/null
}

run_ssm_command "aws s3 cp s3://$BUCKET_NAME/scripts/ /tmp/scripts/ --recursive --quiet"
run_ssm_command "aws s3 cp s3://$BUCKET_NAME/scripts/sql/ /tmp/scripts/sql/ --recursive --quiet"
run_ssm_command "aws s3 cp s3://$BUCKET_NAME/migrations/ /tmp/migrations/ --recursive --quiet"
