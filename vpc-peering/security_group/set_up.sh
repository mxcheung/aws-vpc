#!/bin/bash


# Assign the VPC ID to a variable
WEB_VPC_ID=$(aws ec2 describe-vpcs --query "Vpcs[?Tags[?Key=='Name' && Value=='Web_VPC']].{VpcId:VpcId}" --output text)

# Create a security group
APP_SG_ID=$(aws ec2 create-security-group \
  --group-name WebWordPressSG \
  --description "Allow HTTP access to WordPress" \
  --vpc-id "$WEB_VPC_ID" \
  --query "GroupId" \
  --output text)

echo $APP_SG_ID

echo "Authorize inbound HTTP access"

# Authorize inbound HTTP access
INGRESS_OUTPUT=$(aws ec2 authorize-security-group-ingress \
    --group-id $APP_SG_ID \
    --protocol tcp \
    --port 80 \
    --cidr 0.0.0.0/0
    


# Variables
WEB_VPC_CIDR="192.168.0.0/16"

# Get the Security Group ID for the RDS security group by name
RDS_SG_ID=$(aws ec2 describe-security-groups \
  --filters Name=description,Values=database-group \
  --query "SecurityGroups[0].GroupId" \
  --output text)

echo "RDS Security Group ID: $RDS_SG_ID"

# Add inbound rule to allow MySQL/Aurora from Web_VPC CIDR
aws ec2 authorize-security-group-ingress \
  --group-id "$RDS_SG_ID" \
  --protocol tcp \
  --port 3306 \
  --cidr "$WEB_VPC_CIDR"

echo "Inbound rule added to $RDS_SG_NAME to allow MySQL from $WEB_VPC_CIDR"
