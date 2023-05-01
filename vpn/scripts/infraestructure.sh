#! /bin/bash

echo "start script"
cd ..

echo "start terraform"
terraform init
echo "init done"

echo "start apply"
terraform apply --var-file=conf/group.tfvars -auto-approve
echo "apply done"
IP=$(terraform output -raw public_ip_address)

echo "The value of your ip is: ${IP}"