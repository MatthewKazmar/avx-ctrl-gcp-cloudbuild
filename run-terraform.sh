#!/usr/bin/env bash

if [ -z $1 ]; then
  echo "Specify build step."
  exit 1
fi

STAGE="[$1]:"
BUCKET="bucket=$TF_VAR_state_bucket"
PREFIX="prefix=avx/$1"

echo "$STAGE Running Terraform Init"
terraform -chdir=$1 init -compact-warnings -backend-config=$BUCKET -backend-config=$PREFIX

if [ "$2" = "destroy" ]; then
  echo "$STAGE Running Terraform Destory."
  terraform -chdir=$1 destroy -compact-warnings -auto-approve -lock=false
else
  echo "$STAGE Running Terraform Apply."
  terraform -chdir=$1 apply -compact-warnings -auto-approve -lock=false
fi