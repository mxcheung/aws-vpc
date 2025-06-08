cd /home/cloudshell-user/aws-vpc/vpc-peering/ec2/
KEYPAIR=$(aws ec2 create-key-pair \
  --key-name MyKeyPair \
  --query "KeyMaterial" \
  --output text > MyKeyPair.pem
)
chmod 400 MyKeyPair.pem

echo $KEYPAIR
