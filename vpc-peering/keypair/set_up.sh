#!/bin/bash

KEYPAIR=$(aws ec2 create-key-pair \
  --key-name MyKeyPair \
  --query "KeyMaterial" \
  --output text > MyKeyPair.pem
)
sudo chmod 400 MyKeyPair.pem

echo $KEYPAIR
