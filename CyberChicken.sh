#!/bin/bash

# Title: static-or-dhcp-ip-picker
#

NETMODE BRIDGE

LED OFF

echo "password" | cryptsetup open /dev/sda dm-0

# wait for attached USB
NO_LED=1 USB_WAIT

LED M SOLID

# Make sure the directory exists
mkdir /usb/ipaddress/

LED B SOLID

# Try to get existing subnet of this interface, should be the outside interface
arpIF="eth0"

mySUBNET=$(ip -o -f inet addr show dev $arpIF | awk '/scope global/ {print $4}' | head -n1)

if [ -n "$mySUBNET" ]; then

# Using existing subnet for the if block
CIDR=$mySUBNET

else

# No subnet found, sniffing ARP to find subnet
CIDR=$(tcpdump -n -l -i $arpIF arp -c 1 2>/dev/null | awk '/who-has/ {print $5"/24"}')

LED B FAST    
  echo $CIDR > /usb/ipaddress/var-CIDR.txt

#it is here where a scan can be done or whatever using the discovered IP addressing

fi
  
cryptsetup close /dev/dm-0

#awl done
LED G SOLID
