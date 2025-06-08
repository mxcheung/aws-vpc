#!/bin/bash

cd /home/cloudshell-user/aws-vpc/vpc-peering/user_credentials
. ./set_up.sh

cd /home/cloudshell-user/aws-vpc/vpc-peering/vpc
. ./set_up.sh

cd /home/cloudshell-user/aws-vpc/vpc-peering/subnets
. ./set_up.sh

cd /home/cloudshell-user/aws-vpc/vpc-peering/internet_gateway
. ./set_up.sh

cd /home/cloudshell-user/aws-vpc/vpc-peering/vpc_peering
. ./set_up.sh

cd /home/cloudshell-user/aws-vpc/vpc-peering/security_group
. ./set_up.sh

cd /home/cloudshell-user/aws-vpc/vpc-peering/ec2
. ./set_up.sh
