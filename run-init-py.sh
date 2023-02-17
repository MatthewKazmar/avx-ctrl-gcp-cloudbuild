#!/usr/bin/env bash

BUCKET="bucket=$TF_VAR_state_bucket"
PREFIX="prefix=avx/controller-instance"

echo "[CONTROLLER-INIT-PY]: Running Terraform Init to get Instance remote state."
terraform init -compact-warnings -backend-config=$BUCKET -backend-config=$PREFIX

echo "[CONTROLLER-INIT-PY]: Set environment variables from state."
export AVIATRIX_PRIVATE_IP=$(terraform output -raw controller_private_ip)
export AVIATRIX_CONTROLLER_IP=$(terraform output -raw controller_public_ip)
echo "[CONTROLLER-INIT-PY]: Installing Python3 and requirements."
apk -q add --no-cache python3 py3-requests
cd controller-init-py
echo "[CONTROLLER-INIT-PY]: Running init script."
python3 init.py