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
    
