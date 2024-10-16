#!/bin/sh

# Get the IP address of the host (non-loopback, non-IPv6)
self_ip=$(ifconfig -a | grep -w inet | grep -v '127.0.0.1\|inet6' | awk '{print $2}' | head -n 1 | tr -d "addr:")
if [ -z "${self_ip}" ]; then
    echo "Failed to get own IP address"
    exit 1
fi

echo "Self IP is ${self_ip}"

# Clear existing iptables rules in the filter table
iptables -t filter -F

# Define ports and variables
allowed_tcp_ports="22,80,443,1883,3306,5432"
allowed_tcp_ports2="6379"
restrict_tcp_ports=""
admin_ip=""

########################### INPUT Chain ###################################

# Default policy: Drop all incoming connections
iptables -P INPUT DROP

# Allow established and related connections
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow TCP connections on specified ports
if [ -n "${allowed_tcp_ports}" ]; then
    iptables -A INPUT -p tcp -m multiport --dports ${allowed_tcp_ports} -j ACCEPT
fi

if [ -n "${allowed_tcp_ports2}" ]; then
    iptables -A INPUT -p tcp -m multiport --dports ${allowed_tcp_ports2} -j ACCEPT
fi

# Allow restricted TCP connections from self IP (if any)
if [ -n "${restrict_tcp_ports}" ]; then
    iptables -A INPUT -p tcp -m multiport --dports ${restrict_tcp_ports} -s ${self_ip} -j ACCEPT
fi

# Allow loopback and self IP communication
iptables -A INPUT -s 127.0.0.1 -d 127.0.0.1 -j ACCEPT
iptables -A INPUT -s ${self_ip} -d ${self_ip} -j ACCEPT

# Allow admin IP (if specified)
if [ -n "${admin_ip}" ]; then
    iptables -I INPUT -s ${admin_ip} -j ACCEPT
fi

# Uncomment below to block ICMP (disable ping)
# iptables -A INPUT -p icmp -j DROP

# Uncomment below to enable SYN flood protection
# iptables -N syn-flood
# iptables -A INPUT -p tcp --syn -j syn-flood
# iptables -I syn-flood -p tcp -m limit --limit 30/s --limit-burst 60 -j RETURN
# iptables -A syn-flood -j REJECT
