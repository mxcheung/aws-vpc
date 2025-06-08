
# create aws_access_key_id and aws_secret_access_key via cloudshell
```
git clone https://github.com/mxcheung/aws-vpc.git
cd /home/cloudshell-user/aws-vpc/vpc-peering/user_credentials/

response=$(aws iam create-access-key --output json)

# Write the response to a JSON file
echo "$response" > access-key-response.json

# Extract AccessKeyId and SecretAccessKey from the response file
access_key_id=$(jq -r '.AccessKey.AccessKeyId' access-key-response.json)
secret_access_key=$(jq -r '.AccessKey.SecretAccessKey' access-key-response.json)

# Print the extracted values (optional)
echo "AccessKeyId: $access_key_id"
echo "SecretAccessKey: $secret_access_key"


cd /home/cloudshell-user/aws-vpc/vpc-peering/user_credentials/
. ./set_up.sh
cd /home/cloudshell-user/aws-vpc/vpc-peering/
. ./set_up.sh

```

 

# Reference
https://learn.acloud.guru/handson/b9756e9f-5140-4ec7-b9b7-0ffaed561910/course/certified-solutions-architect-associate
