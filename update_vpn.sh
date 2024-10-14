#!/bin/bash

new_vpn_host=$1
option=$2
vpn_routed_host_file="$HOME/openvpn_profiles/vpn_routed_hosts.txt"

check_input() {
   if [ -z "$new_vpn_host" ]; then
      echo "no host provided"
      echo -e "Usage: script {fqdn} [remove]\n"
      echo -e "$vpn_routed_host_file contains:\n"
   fi
}

add_host() { 
if grep -q "$new_vpn_host" "$vpn_routed_host_file"; then
   echo -e "$new_vpn_host alerady exists in $vpn_routed_host_file \n"
else   
   echo $new_vpn_host >> $vpn_routed_host_file
   if grep -q "$new_vpn_host" "$vpn_routed_host_file"; then
      echo -e "$new_vpn_host added to $vpn_routed_host_file\n" 
   else
      echo -e "error adding $new_vpn_host added to $vpn_routed_host_file\n"
   fi
fi
}

remove_host() {
if [ "$option" = "remove" ]; then
   if grep -q "$new_vpn_host" "$vpn_routed_host_file"; then
      sed -i.bak "/$new_vpn_host/d" "$vpn_routed_host_file"
      echo -e "$new_vpn_host" removed from "$vpn_routed_host_file\n"
   else
      echo -e "$new_vpn_host" not found in "$vpn_routed_host_file\n"
   fi
else
   echo "invalid input option, use 'remove'"
   exit 1
fi
}

check_input
if [ -z "$2" ]; then
   add_host
else
   remove_host
fi 
cat $vpn_routed_host_file

