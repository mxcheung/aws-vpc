#!/bin/bash

set -euo pipefail

# Step 1: Get the VPC ID of Web_VPC
VPC_ID=$(aws ec2 describe-vpcs \
  --filters "Name=tag:Name,Values=Web_VPC" \
  --query "Vpcs[0].VpcId" \
  --output text)

echo "VPC ID: $VPC_ID"

# Step 2: Create Internet Gateway with tag WebIG
IGW_ID=$(aws ec2 create-internet-gateway \
  --tag-specifications 'ResourceType=internet-gateway,Tags=[{Key=Name,Value=WebIG}]' \
  --query "InternetGateway.InternetGatewayId" \
  --output text)

echo "Internet Gateway ID: $IGW_ID"

# Step 3: Attach Internet Gateway to the VPC
aws ec2 attach-internet-gateway \
  --internet-gateway-id "$IGW_ID" \
  --vpc-id "$VPC_ID"

echo "Attached IGW to VPC"

# Step 4: Get the Route Table ID associated with the VPC
ROUTE_TABLE_ID=$(aws ec2 describe-route-tables \
  --filters "Name=vpc-id,Values=$VPC_ID" \
  --query "RouteTables[0].RouteTableId" \
  --output text)

echo "Route Table ID: $ROUTE_TABLE_ID"

# Step 5: Add route to route table for 0.0.0.0/0 via the IGW
aws ec2 create-route \
  --route-table-id "$ROUTE_TABLE_ID" \
  --destination-cidr-block 0.0.0.0/0 \
  --gateway-id "$IGW_ID"

echo "Added route to 0.0.0.0/0 via Internet Gateway"
