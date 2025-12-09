#!/bin/bash

# ----------- CONFIGURABLE INPUTS -------------
AMI_ID="ami-09c813fb71547fc4f"
SG_ID="sg-0f63039a616382c25"          
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