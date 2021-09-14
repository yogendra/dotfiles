#!/bin/bash

set -e

read -p 'NSX-T Server: ' server
read -p 'NSX-T Username: ' username
read -sp 'NSX-T Password: ' password

function nsxt-client(){
  curl -sSL -k -u ${username}:"${password}" -H content-type:application/json https://${server}$*
}
nsxt-client /api/v1/loadbalancer/virtual-servers -X GET | jq -r '.results [] | ( .id + " " + .display_name )'
read -p "Select Virtual Server ID (first column): " vserver_id


# Get server config
nsxt-client /api/v1/loadbalancer/virtual-servers/$vserver_id  >> /tmp/vserver.json

nsxt-client /api/v1/loadbalancer/client-ssl-profiles | jq -r '.results [] | ( .id + " " + .display_name )'
read -p "Select Client SSL Profile ID (first column): " ssl_profile_id

# Just check by querying for selected profile
nsxt-client /api/v1/loadbalancer/client-ssl-profiles/$ssl_profile_id >> /dev/null


jq ".client_ssl_profile_binding.ssl_profile_id = \"$ssl_profile_id\"" /tmp/vserver.json > /tmp/vserver-updated.json

echo "Ready to make the change to $vserver_id (Update client ssl profile to $ssl_profile_id)"

nsxt-client /api/v1/loadbalancer/virtual-server/$vserver_id -X PUT -d @/tmp/vserver-updated.json -H X-Allow-Overwrite:true

rm /tmp/vserver.json /tmp/vserver-update.json






