#!/bin/bash

# Set your variables

# Get the Security Group ID for the RDS security group by name
RDS_SG_ID=$(aws ec2 describe-security-groups \
  --filters Name=description,Values=database-group \
  --query "SecurityGroups[0].GroupId" \
  --output text)

echo "RDS Security Group ID: $RDS_SG_ID"


RDS_ENDPOINT=$(aws rds describe-db-instances \
  --query "DBInstances[?VpcSecurityGroups[?VpcSecurityGroupId=='$RDS_SG_ID']].Endpoint.Address" \
  --output text)

echo "RDS ENDPOINT ID: $RDS_ENDPOINT"

INSTANCE_NAME="WordPressInstance"
INSTANCE_ID=$(aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=$INSTANCE_NAME" \
  --query "Reservations[].Instances[].InstanceId" \
  --output text)

echo " EC2 WordPressInstance instance ID: $INSTANCE_ID"

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
