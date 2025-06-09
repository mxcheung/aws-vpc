#!/bin/bash

sudo cp /home/cloudshell-user/aws-vpc/vpc-peering/keypair/MyKeyPair.pem MyKeyPair.pem 
sudo chmod 400 MyKeyPair.pem 
sudo chown cloudshell-user MyKeyPair.pem 

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



# Get the Security Group ID for the RDS security group by name
RDS_SG_ID=$(aws ec2 describe-security-groups \
  --filters Name=description,Values=database-group \
  --query "SecurityGroups[0].GroupId" \
  --output text)

echo "RDS Security Group ID: $RDS_SG_ID"

RDS_ENDPOINT=$(aws rds describe-db-instances \
  --query "DBInstances[?VpcSecurityGroups[?VpcSecurityGroupId=='$RDS_SG_ID']].Endpoint.Address" \
  --output text)

echo "RDS ENDPOINT: $RDS_ENDPOINT"

ssh -i $KEY_FILE ubuntu@$EC2_PUBLIC_IP  << 'EOF'
sudo sed -i "s/'DB_HOST', *'localhost'/'DB_HOST', '$RDS_ENDPOINT'/g" /var/www/wordpress/wp-config.php
EOF
