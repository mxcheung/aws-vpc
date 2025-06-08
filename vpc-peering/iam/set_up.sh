#!/bin/bash
set -e

ROLE_NAME="EC2SSMRole"
INSTANCE_PROFILE_NAME="$ROLE_NAME"
POLICY_ARN="arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"

# Check if IAM Role exists, create if not
if ! aws iam get-role --role-name "$ROLE_NAME" >/dev/null 2>&1; then
  echo "Creating IAM role $ROLE_NAME..."
  aws iam create-role --role-name "$ROLE_NAME" --assume-role-policy-document '{
    "Version": "2012-10-17",
    "Statement": [{
      "Effect": "Allow",
      "Principal": { "Service": "ec2.amazonaws.com" },
      "Action": "sts:AssumeRole"
    }]
  }'

echo "Attaching policy $POLICY_ARN to role..."
aws iam attach-role-policy --role-name "$ROLE_NAME" --policy-arn "$POLICY_ARN"
