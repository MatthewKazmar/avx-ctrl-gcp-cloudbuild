#!/bin/sh

echo "[APPLY] Installing Python3 and requirements."
apk add --no-cache python3 py3-pip
pip install -r .terraform/modules/aviatrix-controller-gcp/requirements.txt

echo "[APPLY] Running Terraform apply."
terraform apply