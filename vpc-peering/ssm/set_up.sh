#!/bin/bash

# Set your variables
RDS_ENDPOINT="your-rds-endpoint.rds.amazonaws.com"
INSTANCE_ID="i-xxxxxxxxxxxxxxxxx"  # Replace with your EC2 instance ID
FILE_PATH="/var/www/wordpress/wp-config.php"

# Construct the sed command
SED_COMMAND="sudo sed -i \"s/'DB_HOST', *'localhost'/'DB_HOST', '$RDS_ENDPOINT'/g\" $FILE_PATH"

# Run sed remotely via AWS SSM
aws ssm send-command \
  --instance-ids "$INSTANCE_ID" \
  --document-name "AWS-RunShellScript" \
  --comment "Update wp-config.php with RDS endpoint" \
  --parameters commands="$SED_COMMAND" \
  --region YOUR_REGION_HERE
