'''
init.py
This script nitializes an Aviatrix Controller.
It needs these environment variables defined from cloudbuild.yaml.
  AVIATRIX_CONTROLLER_IP
  AVIATRIX_USERNAME
  AVIATRIX_PASSWORD

'''

from pyavx_init import Pyavx_Init
import os

# Get environment variables
data = {
  'oldpw': os.getenv('AVIATRIX_PRIVATE_IP'),
  'pw': os.getenv('AVIATRIX_PASSWORD'),
  'email': os.getenv('AVIATRIX_CONTROLLER_ADMIN_EMAIL'),
  'customer_id': os.getenv('AVIATRIX_CUSTOMER_ID'),
  'target_version': os.getenv('AVIATRIX_TARGET_VERSION')
}

init = Pyavx_Init(**data)

if init.connected:
  print('success')
  exit(0)
else:
  print('failure')
  exit(1)