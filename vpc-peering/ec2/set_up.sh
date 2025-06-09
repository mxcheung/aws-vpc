#!/bin/bash

set -euo pipefail

IAM_INSTANCE_PROFILE_NAME="EC2SSMRole"  # must match role created above

sudo cp /home/cloudshell-user/aws-vpc/vpc-peering/keypair/MyKeyPair.pem MyKeyPair.pem 
sudo chmod 400 MyKeyPair.pem 
KEY_NAME="MyKeyPair"

# Get VPC ID
WEB_VPC_ID=$(aws ec2 describe-vpcs \
  --filters "Name=tag:Name,Values=Web_VPC" \
  --query "Vpcs[0].VpcId" \
  --output text)

# Get Subnet ID (WebPublic)
SUBNET_ID=$(aws ec2 describe-subnets \
  --filters "Name=vpc-id,Values=$WEB_VPC_ID" "Name=tag:Name,Values=WebPublic" \
  --query "Subnets[0].SubnetId" \
  --output text)

# Get the latest Ubuntu 24.04 LTS AMI ID in the region
AMI_ID=$(aws ec2 describe-images \
  --owners 099720109477 \
  --filters "Name=name,Values=ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*" \
            "Name=architecture,Values=x86_64" \
            "Name=root-device-type,Values=ebs" \
            "Name=virtualization-type,Values=hvm" \
  --query "Images | sort_by(@, &CreationDate)[-1].ImageId" \
  --output text)

# ami-0731becbf832f281e

# Find security group with name WebWordPressSG
SG_ID=$(aws ec2 describe-security-groups --filters Name=group-name,Values=WebWordPressSG --query "SecurityGroups[0].GroupId" --output text)

echo "Using AMI ID: $AMI_ID"
echo "Subnet ID: $SUBNET_ID"
echo "Security Group ID: $SG_ID"

# Launch the EC2 instance
INSTANCE_ID=$(aws ec2 run-instances \
  --image-id "$AMI_ID" \
  --instance-type t3.micro \
  --subnet-id "$SUBNET_ID" \
  --associate-public-ip-address \
  --key-name "$KEY_NAME" \
  --security-group-ids "$SG_ID" \
  --iam-instance-profile Name="$IAM_INSTANCE_PROFILE_NAME" \
  --user-data file://user_data.sh \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=WordPressInstance}]' \
  --query "Instances[0].InstanceId" \
  --output text)

echo "Launched EC2 Instance: $INSTANCE_ID"
