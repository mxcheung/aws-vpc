KEYPAIR=$(aws ec2 create-key-pair \
  --key-name MyKeyPair \
  --query "KeyMaterial" \
  --output text > MyKeyPair.pem
)
chmod 400 MyKeyPair.pem

echo $KEYPAIR
