#!/usr/bin/env python

"""Check that the floats nova assigned on the local host are same
as those in the routing tables.

Standard nova-like options.
Returns a little json

"""


def get_nova_floats(username, password, tenant, auth_url):
   """Query nova for the current hosted floats. Results a *set*
   of ips. 
   """
   from novaclient.v1_1 import client
   nova = client.Client(username, password, tenant, auth_url)
   return set( [ str(a.address) for a in nova.floating_ips_bulk.list(os.uname()[1]) ] )
            

def get_iptables_floats(cidr, interface):
   import netaddr
   import subprocess 
   ipn = netaddr.IPNetwork(cidr)
   sp = subprocess.Popen(["ip", "addr", "show", interface], stdout=subprocess.PIPE)
   sp.wait()
   sou , ser  = sp.communicate()

   ips = []
   for line in sou.split("\n"):
      line = line.strip()
      if line.startswith("inet"):
         ip = line.split(" ")[1]
         ip, bm = ip.split("/")
         if bm=="32" and netaddr.IPAddress(ip) in ipn:
            ips.append(ip)
            
   return set(ips)
      

if __name__ == '__main__':
   
   from optparse import OptionParser 
   import sys
   import os
   
   parser = OptionParser(usage="%prog [options]", version="%prog 0.1")
   parser.add_option("-u", "--os_username", dest="os_username", type="string",
                     default=os.environ.get("OS_USERNAME", ""),                     
                     help="The openstack username [%default]")
   parser.add_option("-p", "--os_password", dest="os_password", type="string",
                     default=os.environ.get("OS_PASSWORD", ""),                     
                     help="The openstack password [**from env**]")
   parser.add_option("-t", "--os_tenant_name", dest="os_tenant_name", type="string",
                     default=os.environ.get("OS_TENANT_NAME", "AdminTentant"),                     
                     help="The openstack Tenant Name [%default]")
   parser.add_option("-l", "--os_auth_url", dest="os_auth_url", type="string",
                     default=os.environ.get("OS_AUTH_URL", "https://127.0.0.1"),                     
                     help="The openstack Tenant Name [%default]")

   parser.add_option("-c", "--cidr", dest="cidr", type="string",
                     default="",
                     help="The float cidr [%default]")
   parser.add_option("-i", "--interface", dest="interface", type="string",
                     default="eth5",
                     help="The float ip interface [%default]")
   (options, args) = parser.parse_args()

   if not options.cidr:
      parser.error("The --cidr 'option' must be supplied, I can't guess this")
   
   assigned_floating_ips = get_nova_floats(options.os_username,
                                           options.os_password,
                                           options.os_tenant_name,
                                           options.os_auth_url)
   bound_floating_ips = get_iptables_floats(options.cidr, options.interface)   
   problem_ips = bound_floating_ips.difference(assigned_floating_ips)
   if problem_ips:
      print "ERROR : %s " % (", ".join(problem_ips))
   else:
      print "OKAY"
                             
