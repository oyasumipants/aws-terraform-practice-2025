#!/bin/bash

set -e

ENV=${1:-techXX}
MIGRATIONS_DIR="/tmp/migrations"

SECRET_NAME="/rds/bookshelf/bookshelf-password"

SECRET_JSON=$(aws secretsmanager get-secret-value --secret-id "$SECRET_NAME" --query SecretString | jq fromjson)

DB_HOST=$(echo $SECRET_JSON | jq -r '.host')
DB_PORT=$(echo $SECRET_JSON | jq -r '.port // "3306"')
DB_NAME=$(echo $SECRET_JSON | jq -r '.dbname')
DB_USER=$(echo $SECRET_JSON | jq -r '.username')
DB_PASSWORD=$(echo $SECRET_JSON | jq -r '.password')

if ! command -v goose &> /dev/null; then
  echo "Installing goose migration tool..."
  go install github.com/pressly/goose/v3/cmd/goose@latest
  export PATH=$PATH:$HOME/go/bin
fi

if [ ! -d "$MIGRATIONS_DIR" ]; then
  echo "Error: Migration directory not found: $MIGRATIONS_DIR"
  echo "Please run the script to transfer migration files to EC2 first."
  exit 1
fi

CONNECTION_STRING="${DB_USER}:${DB_PASSWORD}@tcp(${DB_HOST}:${DB_PORT})/${DB_NAME}"

cd $MIGRATIONS_DIR

goose mysql "$CONNECTION_STRING" up
