#!/usr/bin/env bash

STAGE="[$1]:"
BUCKET="bucket=$TF_VAR_state_bucket"
PREFIX="prefix=avx/$1"

echo "$(STAGE) Running Terraform Init"
terraform -chdir=$1 -compact-warnings -backend-config=BUCKET -backend-config=PREFIX
echo "$(STAGE) Running Terraform Apply."
terraform -chdir=$1 -compact-warnings -auto-approve -lock=false