#!/bin/bash

sudo cp /home/cloudshell-user/aws-vpc/vpc-peering/keypair/MyKeyPair.pem MyKeyPair.pem 
sudo chmod 400 MyKeyPair.pem 
sudo chown cloudshell-user

KEY_FILE="MyKeyPair.pem"

INSTANCE_NAME="WordPressInstance"
INSTANCE_ID=$(aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=$INSTANCE_NAME" \
  --query "Reservations[].Instances[].InstanceId" \
  --output text)

echo "EC2 WordPressInstance instance ID: $INSTANCE_ID"

EC2_PUBLIC_IP=$(aws ec2 describe-instances \
  --instance-ids "$INSTANCE_ID" \
  --query "Reservations[0].Instances[0].PublicIpAddress" \
  --output text)

echo "EC2 PUBLIC IP: $EC2_PUBLIC_IP"


FILE_PATH="/var/www/wordpress/wp-config.php"

ssh -i $KEY_FILE ubuntu@$EC2_PUBLIC_IP     # Ubuntu
