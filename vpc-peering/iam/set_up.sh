#!/bin/bash
set -e

ROLE_NAME="EC2SSMRole"
INSTANCE_PROFILE_NAME="$ROLE_NAME"
POLICY_ARN="arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"

# Check if IAM Role exists, create if not
if ! aws iam get-role --role-name "$ROLE_NAME" >/dev/null 2>&1; then
  echo "Creating IAM role $ROLE_NAME..."
  IAM_ROLE_OUTPUT=$(aws iam create-role --role-name "$ROLE_NAME" --assume-role-policy-document '{
    "Version": "2012-10-17",
    "Statement": [{
      "Effect": "Allow",
      "Principal": { "Service": "ec2.amazonaws.com" },
      "Action": "sts:AssumeRole"
    }]
  }')
  echo "IAM_ROLE_OUTPUT $IAM_ROLE_OUTPUT IAM role $ROLE_NAME..."
  echo "Attaching policy $POLICY_ARN to role..."
  aws iam attach-role-policy --role-name "$ROLE_NAME" --policy-arn "$POLICY_ARN"

  echo "Creating instance profile $INSTANCE_PROFILE_NAME..."
  aws iam create-instance-profile --instance-profile-name "$INSTANCE_PROFILE_NAME"

  echo "Adding role to instance profile..."
  aws iam add-role-to-instance-profile --instance-profile-name "$INSTANCE_PROFILE_NAME" --role-name "$ROLE_NAME"

  echo "Waiting for instance profile propagation..."
  sleep 10
else
  echo "IAM role $ROLE_NAME already exists."
fi
