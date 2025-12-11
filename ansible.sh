#!/bin/bash

# ----------- CONFIGURABLE INPUTS -------------
AMI_ID="ami-09c813fb71547fc4f"
SG_ID="sg-0189b141d2540e99f"          
# ----------------------------------------------

# ---------- CLOUD-INIT USER DATA -------------
USER_DATA=$(cat << 'EOF'
#cloud-config
packages:
  - ansible
runcmd:
  - dnf install -y ansible
EOF
)
# ----------------------------------------------

echo "Launching EC2 instance..."

aws ec2 run-instances \
  --image-id "$AMI_ID" \
  --instance-type t3.micro \
  --security-group-ids "$SG_ID" \
  --user-data "$USER_DATA" \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=Ansible-Host}]'

# Fetch IPs
PUBLIC_IP=$(aws ec2 describe-instances \
  --instance-ids "$INSTANCE_ID" \
  --query "Reservations[0].Instances[0].PublicIpAddress" \
  --output text)

PRIVATE_IP=$(aws ec2 describe-instances \
  --instance-ids "$INSTANCE_ID" \
  --query "Reservations[0].Instances[0].PrivateIpAddress" \
  --output text)

echo "---------------------------------"
echo "EC2 Instance Details"
echo "Instance ID : $INSTANCE_ID"
echo "Public IP   : $PUBLIC_IP"
echo "Private IP  : $PRIVATE_IP"
echo "---------------------------------"