'''
Class to connect to the Aviatrix Controller and run some APIs.
'''

import os, socket, time
import requests

class Pyavx:
  def api_call(self, data, method='post', version='v1'):
    '''
    Post Aviatrix API with version specified, run the specified cmd.
    '''
    method = method.lower()
    if method not in ['get', 'post']:
      print(f'Method sent was {method}. Method must be either GET or POST, defaulting to POST.')
      method = 'post'

    version = version.lower()  
    if version not in ['v1', 'v2']:
      print(f'Version sent was {version}. API version must be v1 or v2. Defaulting to v1.')
      version = 'v1'

    if self.cid:
      data['CID'] = self.cid
   
    url = f'https://{self.ip}/{version}/api'
    try:
      if method == 'post':
        response = requests.post(url, headers=self.headers, data=data, verify=False)
      elif method == 'get':
        response = requests.get(url, headers=self.headers, params=data, verify=False)
    except Exception as e:
      return { 'return': False,
               'reason' : f'Got exception.\n {e}' }

    # Anything not 200 is a failure.    
    if response.status_code != 200:
      return { 'return': False,
               'reason' : f'Got non-200 response code {response.status_code}' }
    
    return response.json()

  def get_headers(self):
    '''
    Build headers for future api calls.
    '''
    # Get current api token.
    status, api_token = self.get_api_token()
    if api_token:
      self.headers['X-Access-Key'] = api_token

    return status

  def get_api_token(self):
    '''
    Get Aviatrix api token.
    '''
    data = {
      'action': 'get_api_token'
    }
    r = self.api_call(data, version='v2')

    if r.get('return'):
      return True, r['results'].get('api_token')
    else:    
      # Returned 200 but got error.
      reason = r.get('reason')
      # if get_api_token returns this, we're below 7.0 and don't need it.
      if reason:
        if 'Valid action required:' in reason:
            return True, None
        else:  
          print(f'Error getting API token. {reason}')
          return False, None

  def get_cid(self, u, p):
    '''
    Get new CID.
    '''
    # Get CID
    data = {
      'action': 'login',
      'username' : u,
      'password' : p
    }

    r = self.api_call(data, version='v2')

    if r.get('return'):
      cid = r.get('CID')
      if cid:
        self.cid = cid
        return True, ''
    else:
      reason = r.get('reason')
      print(f'Error getting CID. {reason}')
      return False, reason

  def tcpping(self):
    '''
    Sends a TCP handshake to port 443 with short timeout.
    Success is when the handshake completes.
    '''
    try:
      s = socket.create_connection((self.ip, 443), timeout=5)
    except:
      s.close()
      return False
    
    s.close()
    return True
       
  def connect(self, u=None, p=None):
    '''
    Checks to make sure the Controller and API are reachable.
    Tries to get the API token, then tries to log in.
    '''
    self.cid = None
    self.headers = {}

    attempts = 10
    delay = 30
    #Wait until controller completes a TCP handshake on 443.
    #attempts/delay as 10/30 will wait 5 minutes.
    
    attempt = 0
    while attempt < attempts:
      tcpping = self.tcpping()
      if tcpping:
        break
      attempt = attempt + 1
      time.sleep(delay)

    if not tcpping:
      return False
    
    #Controller is TCP Handshaking now. Let's try to log in and get the CID.    
    if not u:
      u = os.getenv('AVIATRIX_USERNAME')

    if not p:
      p = os.getenv('AVIATRIX_PASSWORD')

    connected = False
    attempt = 0
    while attempt < attempts:
      if self.get_headers():
        connected, error = self.get_cid(u, p)
        if connected:
          break
        if 'username and password do not match' in error:
          break
      attempt = attempt + 1
      time.sleep(delay)

    self.connected = connected

    return connected

  def __init__(self, ip=None, u=None, p=None):
    '''
    Username/pw/controller ip in environment just like terraform.
    
    $ export AVIATRIX_CONTROLLER_IP="1.2.3.4"
    $ export AVIATRIX_USERNAME="admin"
    $ export AVIATRIX_PASSWORD="password"

    PS> Set-Item -Path Env:AVIATRIX_CONTROLLER_IP -Value '1.2.3.4'
    PS> Set-Item -Path Env:AVIATRIX_USERNAME -Value 'admin'
    PS> Set-Item -Path Env:AVIATRIX_PASSWORD -Value 'password'
    '''

    requests.packages.urllib3.disable_warnings()

    if ip: 
      self.ip = ip
    else:
      self.ip = os.getenv('AVIATRIX_CONTROLLER_IP')

    self.connected = False

    # Get API token and CID.
    # Can call connect again if the controller session is invalid due to password change or update.
    #self.connect(u, p)