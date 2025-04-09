#!/bin/bash

set -e

ENV=${1:-techXX}
SCRIPTS_DIR="./db/scripts"
MIGRATIONS_DIR="./db/migrations"

BUCKET_NAME="${ENV}-operation-scripts"

aws s3api head-object --bucket "$BUCKET_NAME" --key "scripts/" >/dev/null 2>&1 || aws s3api put-object --bucket "$BUCKET_NAME" --key "scripts/" --output text >/dev/null

for file in $SCRIPTS_DIR/*.sh; do
  filename=$(basename "$file")
  echo "Uploading $filename to S3..."
  aws s3 cp "$file" "s3://$BUCKET_NAME/scripts/$filename" --quiet
  
  aws s3api put-object-acl --bucket "$BUCKET_NAME" --key "scripts/$filename" --acl private --output text > /dev/null
done

for file in $SCRIPTS_DIR/sql/*.sql; do
  filename=$(basename "$file")
  echo "Uploading $filename to S3..."
  aws s3 cp "$file" "s3://$BUCKET_NAME/scripts/sql/$filename" --quiet
  
  aws s3api put-object-acl --bucket "$BUCKET_NAME" --key "scripts/sql/$filename" --acl private --output text > /dev/null
done

for file in $MIGRATIONS_DIR/*.sql; do
  filename=$(basename "$file")
  echo "Uploading $filename to S3..."
  aws s3 cp "$file" "s3://$BUCKET_NAME/migrations/$filename" --quiet
  
  aws s3api put-object-acl --bucket "$BUCKET_NAME" --key "migrations/$filename" --acl private --output text > /dev/null
done
