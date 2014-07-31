#!/bin/bash
/sbin/iptables -A INPUT -i venet0 -j ACCEPT
/sbin/iptables -A OUTPUT -o venet0 -j ACCEPT
/sbin/iptables -A FORWARD -j ACCEPT -p all -s 0/0 -i venet0
/sbin/iptables -A FORWARD -j ACCEPT -p all -s 0/0 -o venet0
/sbin/iptables -A INPUT -m addrtype --dst-type MULTICAST -j ACCEPT
