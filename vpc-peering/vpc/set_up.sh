#!/bin/bash

echo "Creating VPC Web_VPC"

VPC=$(aws ec2 create-vpc \
  --cidr-block 192.168.0.0/16 \
  --tag-specifications 'ResourceType=vpc,Tags=[{Key=Name,Value=Web_VPC}]')

echo $VPC
