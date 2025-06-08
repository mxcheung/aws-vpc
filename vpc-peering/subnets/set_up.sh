#!/bin/bash

set -euo pipefail

# Fetch the VPC ID for Web_VPC
VPC_ID=$(aws ec2 describe-vpcs \
  --query "Vpcs[?Tags[?Key=='Name' && Value=='Web_VPC']].VpcId" \
  --output text)

echo "VPC ID: $VPC_ID"

# Create a subnet in the specified VPC and AZ
SUBNET_ID=$(aws ec2 create-subnet \
  --vpc-id "$VPC_ID" \
  --cidr-block 192.168.0.0/24 \
  --availability-zone us-east-1a \
  --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=WebPublic}]' \
  --query "Subnet.SubnetId" \
  --output text)

echo "Subnet ID: $SUBNET_ID"
