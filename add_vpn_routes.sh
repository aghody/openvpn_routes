#!/bin/bash
 
VPN_INTERFACE=utun4
MESSAGE_UP="VPN Inferface ($VPN_INTERFACE) is up."
logfile="/Users/aghody/openvpn_profiles/vpn_routed_hosts.log"

touch $logfile

#echo ${vpn_routed_hosts[@]}

update_timestamp() {
    TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
}

is_vpn_interface_up() {
  ifconfig $VPN_INTERFACE >/dev/null 2>&1
       if [ "$?" -eq 0 ] ; then
       if grep -q "$MESSAGE_UP" $logfile; then
          sed -i.bak "/$MESSAGE_UP/d" $logfile
       fi
       echo -e "[$TIMESTAMP] $MESSAGE_UP" >> $logfile
       return 0
    else
        echo "[$TIMESTAMP] VPN INTERFACE ($VPN_INTERFACE) is down" > $logfile
        return 1  # Interface is not up
    fi
}
add_route() { 
     vpn_routed_hosts=`cat /Users/aghody/openvpn_profiles/vpn_routed_hosts.txt`
     for ROUTED_HOST in ${vpn_routed_hosts[@]}
       do 
       {
         IP_ADDRESSES=$(dig +short $ROUTED_HOST | grep -v '\.$' )

    # Check if any IP addresses were resolved for the parent domain
         if [ -z "$IP_ADDRESSES" ]; then
            echo "[$TIMESTAMP] Failed to resolve domain: $ROUTED_HOST" >> $logfile 
            exit 1
         fi

   # Add route for the parent domain IP addresses
        for IP in $IP_ADDRESSES; do
          echo "Routing $ROUTED_HOST ($IP) through VPN interface $VPN_INTERFACE" > /dev/null
          if ! netstat -rn | grep -q $IP; then
               echo "[$TIMESTAMP] Adding route to $IP via $VPN_INTERFACE" >> $logfile 
               route add -host $IP -interface $VPN_INTERFACE >> $logfile
          else 
               echo "Route Already Exists" > /dev/null
          fi
        done    
       }
      done
}

while true; do
    update_timestamp
    if is_vpn_interface_up; then
       add_route
    fi
    # Sleep for 5 seconds before checking again
    sleep 5
done
