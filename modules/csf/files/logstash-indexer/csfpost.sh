#!/bin/bash
/sbin/iptables -t nat -F PREROUTING
/sbin/iptables -t nat -A PREROUTING -p udp --dport 514 -j REDIRECT --to-ports 5514
/sbin/iptables -t nat -A PREROUTING -p tcp --dport 514 -j REDIRECT --to-ports 5514
