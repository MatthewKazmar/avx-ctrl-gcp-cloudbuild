from pyavx import Pyavx
import os, time

class Pyavx_Init(Pyavx):
  def set_adminpw(self, oldpw):
    '''
    Checks/sets admin pw.
    '''
    data = {
      'action': 'edit_account_user',
      'username': 'admin',
      'what': 'password',
      'old_password': oldpw,
      'new_password': os.getenv('AVIATRIX_PASSWORD')
    }
    r = self.api_call(data)
    if r['return']:
      print('Admin password changed.')
    else:
      reason = r['reason']
      print('Error changing admin password.\nReason: {reason}')

  def set_adminemail(self, email):
    data = {
      'action': 'add_admin_email_addr',
      'admin_email': email
    }
    r = self.api_call(data)
    if r['return']:
      print('Admin email set.')
    else:
      reason = r['reason']
      print(f'Error setting admin email. {reason}')
      return

  def set_customerid(self, customer_id):
    '''
    Checks and sets company.
    '''
    data = {
      'action': 'list_customer_id'
    }

    r = self.api_call(data, method='get')

    if r['return']:
      results = r.get('results')
      if results:
        print(f'Customer id is {results}. Not changing.')
        return
  
    data = {
      'action': 'setup_customer_id',
      'customer_id': customer_id
    }
    r = self.api_call(data)
    if r['return']:
      print('Successfully set customer id.')
    else:
      print('Failed to set customer id.')

  def set_initialconfig(self, target_version=None):
    '''
    Checks if controller is initialized and does it if needed.
    '''
    data = {
      'action': 'initial_setup',
      'subaction': 'check'
    }

    r = self.api_call(data)
    if r['return']:
      print('Initial config is done.')
    else:
      if not target_version:
        target_version = 'latest'
      data = {
        'action': 'initial_setup',
        'subaction': 'run',
        'target_version': target_version
      }
      r = self.api_call(data)
      if r['return']:
        print('Applied initial config.')
      else:
        print('Error applying initial configuration.')
        return False

  
  def __init__(self, **kwargs):
    '''
    Valid kwargs are:
    - private ip of controller as initial pw
    - admin pw
    - admin email
    - license
    - target version for initial configuration
    '''

    Pyavx.__init__(self)

    if not self.ip:
      return
    
    # See if we can login with the private ip
    oldpw = kwargs.get('oldpw')
    email = kwargs.get('email')
    if oldpw:
      if self.connect(p=oldpw):
        adminpw_set = False
        print('Logged into the controller using the private IP.')
    if not self.connected:
      # Try the environment variables
      if self.connect():
        adminpw_set = True
        print('Logged into the controller with AVIATRIX_PASSWORD.')
      else:
        print('Cannot log into Controller using private ip or environment variables.')
        exit(1)

    if not adminpw_set:
      self.set_adminpw(oldpw)

    email = kwargs.get('email')
    if email:
      self.set_adminemail(email)

    customer_id = kwargs.get('customer_id')
    if customer_id:
      self.set_customerid(customer_id)

    self.set_initialconfig(kwargs.get('target_version'))

    self.connect()
    