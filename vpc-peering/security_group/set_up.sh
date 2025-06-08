#!/bin/bash


# Assign the VPC ID to a variable
WEB_VPC_ID=$(aws ec2 describe-vpcs --query "Vpcs[?Tags[?Key=='Name' && Value=='Your Custom VPC']].{VpcId:VpcId}" --output text)

# Create a security group
SG_ID=$(aws ec2 create-security-group \
  --group-name WebWordPressSG \
  --description "Allow HTTP access to WordPress" \
  --vpc-id "$WEB_VPC_ID" \
  --query "GroupId" \
  --output text)

