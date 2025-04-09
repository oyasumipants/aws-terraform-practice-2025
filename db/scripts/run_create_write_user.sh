#!/bin/bash

set -e

ENV=${1:-techXX}
SCRIPTS_DIR="/tmp/scripts"
SQL_DIR="${SCRIPTS_DIR}/sql"

SECRET_NAME="/rds/bookshelf/bookshelf-password"

SECRET_JSON=$(aws secretsmanager get-secret-value --secret-id "$SECRET_NAME" --query SecretString | jq fromjson)

DB_HOST=$(echo $SECRET_JSON | jq -r '.host')
DB_PORT=$(echo $SECRET_JSON | jq -r '.port // "3306"')
DB_NAME=$(echo $SECRET_JSON | jq -r '.dbname')
ADMIN_USER=$(echo $SECRET_JSON | jq -r '.admin_username')
ADMIN_PASSWORD=$(echo $SECRET_JSON | jq -r '.admin_password')
WRITE_USER_PASSWORD=$(echo $SECRET_JSON | jq -r '.password')

if [ ! -d "$SQL_DIR" ]; then
  echo "Error: SQL directory not found: $SQL_DIR"
  echo "Please run the script to transfer script files to EC2 first."
  exit 1
fi

echo "Creating write user for Aurora cluster..."
# Replace the placeholder with the actual password from Secrets Manager
sed "s/\${write_user_password}/$WRITE_USER_PASSWORD/g" $SQL_DIR/create_write_user.sql > $SCRIPTS_DIR/create_write_user_temp.sql

# Execute the SQL using the admin user
mysql -h $DB_HOST -P $DB_PORT -u $ADMIN_USER -p$ADMIN_PASSWORD < $SCRIPTS_DIR/create_write_user_temp.sql

# Clean up the temporary file
rm $SCRIPTS_DIR/create_write_user_temp.sql

echo "Write user created successfully." 
