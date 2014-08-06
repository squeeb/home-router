#!/bin/bash
/sbin/iptables -A INPUT -i venet0 -j ACCEPT
/sbin/iptables -A OUTPUT -o venet0 -j ACCEPT
/sbin/iptables -A FORWARD -j ACCEPT -p all -s 0/0 -i venet0
/sbin/iptables -A FORWARD -j ACCEPT -p all -s 0/0 -o venet0
/sbin/iptables -A INPUT -m addrtype --dst-type MULTICAST -j ACCEPT
/sbin/iptables -t nat -A POSTROUTING -s '10.2.100.0/24' -o vmbr0 -j MASQUERADE
/sbin/iptables -t nat -D POSTROUTING -s '10.2.100.0/24' -o vmbr0 -j MASQUERADE
