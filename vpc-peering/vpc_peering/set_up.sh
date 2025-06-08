#!/bin/bash

set -euo pipefail

# Get the VPC IDs
DB_VPC_ID=$(aws ec2 describe-vpcs \
  --filters "Name=tag:Name,Values=DB_VPC" \
  --query "Vpcs[0].VpcId" \
  --output text)

WEB_VPC_ID=$(aws ec2 describe-vpcs \
  --filters "Name=tag:Name,Values=Web_VPC" \
  --query "Vpcs[0].VpcId" \
  --output text)

echo "DB_VPC ID: $DB_VPC_ID"
echo "Web_VPC ID: $WEB_VPC_ID"

# Create the peering connection
PEERING_ID=$(aws ec2 create-vpc-peering-connection \
  --vpc-id "$DB_VPC_ID" \
  --peer-vpc-id "$WEB_VPC_ID" \
  --tag-specifications 'ResourceType=vpc-peering-connection,Tags=[{Key=Name,Value=DBtoWeb}]' \
  --query "VpcPeeringConnection.VpcPeeringConnectionId" \
  --output text)

echo "Peering Connection ID: $PEERING_ID"

# Accept the peering connection
aws ec2 accept-vpc-peering-connection \
  --vpc-peering-connection-id "$PEERING_ID"

echo "Peering connection accepted"

# Get route table for Web_VPC
WEB_RT_ID=$(aws ec2 describe-route-tables \
  --filters "Name=vpc-id,Values=$WEB_VPC_ID" \
  --query "RouteTables[0].RouteTableId" \
  --output text)

# Add route in Web_VPC for DB_VPC range (10.0.0.0/16)
aws ec2 create-route \
  --route-table-id "$WEB_RT_ID" \
  --destination-cidr-block 10.0.0.0/16 \
  --vpc-peering-connection-id "$PEERING_ID"

echo "Added route to Web_VPC route table for 10.0.0.0/16 via peering"

# Get route table for DB_VPC (main route table)
DB_RT_ID=$(aws ec2 describe-route-tables \
  --filters "Name=vpc-id,Values=$DB_VPC_ID" \
  --query "RouteTables[?Associations[?Main==\`true\`]].RouteTableId" \
  --output text)

# Add route in DB_VPC for Web_VPC range (192.168.0.0/16)
aws ec2 create-route \
  --route-table-id "$DB_RT_ID" \
  --destination-cidr-block 192.168.0.0/16 \
  --vpc-peering-connection-id "$PEERING_ID"

echo "Added route to DB_VPC route table for 192.168.0.0/16 via peering"
