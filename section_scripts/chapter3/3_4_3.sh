#!/bin/bash

# 3.4.3.1.1 Ensure iptables packages are installed

if rpm -q iptables ip tables-services &> /dev/null; then
    echo "iptables installed, continuing..."
else   
    echo "ip tables not found, installing..."
    dnf -y install iptables iptables-services &> /dev/null
fi

# 3.4.3.1.2 Ensure nftables is not installed with iptables

if rpm -q nftables &> /dev/null; then
    echo "nftables installed, removing..."
    dnf remove nftables &> /dev/null
else
    echo "nftables not installed, continuing..."
fi

# 3.4.3.1.3 Ensure firewalld is removed or masked with iptables

if rpm -q firewalld &> /dev/null; then
    echo "firewalld installed, removing..."
    dnf remove firewalld &> /dev/null
else
    echo "firewalld not installed, continuing..."
fi

# 

# Flush IPtables rules 

iptables -F 

# Ensure default deny firewall policy 

iptables -P INPUT DROP iptables -P OUTPUT DROP iptables -P FORWARD DROP 

# Ensure loopback traffic is configured 

iptables -A INPUT -i lo -j ACCEPT iptables -A OUTPUT -o lo -j ACCEPT 

iptables -A INPUT -s 127.0.0.0/8 -j DROP 

# Ensure outbound and established connections are configured 

iptables -A OUTPUT -p tcp -m state --state NEW,ESTABLISHED -j ACCEPT 

iptables -A OUTPUT -p udp -m state --state NEW,ESTABLISHED -j ACCEPT 

iptables -A OUTPUT -p icmp -m state --state NEW,ESTABLISHED -j ACCEPT 

iptables -A INPUT -p tcp -m state --state ESTABLISHED -j ACCEPT 

iptables -A INPUT -p udp -m state --state ESTABLISHED -j ACCEPT 

iptables -A INPUT -p icmp -m state --state ESTABLISHED -j ACCEPT 

# Open inbound ssh(tcp port 22) connections 

iptables -A INPUT -p tcp --dport 22 -m state --state NEW -j ACCEPT

# 3.4.3.2.4 Ensure iptables default deny firewall policy

iptables -p INPUT DROP
iptables -p OUTPUT DROP
iptables -P FORWARD DROP

# 3.4.3.2.5 Ensure iptables config is saved

service iptables save

# 3.4.3.2.6 Ensure iptables is enabled and active

if systemctl is-active iptables | grep "active" &> /dev/null; then
    echo "iptables is activated, continuing..."
else
    echo "Activating iptables..."
    systemctl --now enable iptables
fi

# Flush ip6tables rules 
ip6tables -F 

# Ensure default deny firewall policy 

ip6tables -P INPUT DROP ip6tables -P OUTPUT DROP ip6tables -P FORWARD DROP 

# Ensure loopback traffic is configured 

ip6tables -A INPUT -i lo -j ACCEPT ip6tables -A OUTPUT -o lo -j ACCEPT ip6tables -A INPUT -s ::1 -j DROP 

# Ensure outbound and established connections are configured 

ip6tables -A OUTPUT -p tcp -m state --state NEW,ESTABLISHED -j ACCEPT 

ip6tables -A OUTPUT -p udp -m state --state NEW,ESTABLISHED -j ACCEPT 

ip6tables -A OUTPUT -p icmp -m state --state NEW,ESTABLISHED -j ACCEPT 

ip6tables -A INPUT -p tcp -m state --state ESTABLISHED -j ACCEPT 

ip6tables -A INPUT -p udp -m state --state ESTABLISHED -j ACCEPT 

ip6tables -A INPUT -p icmp -m state --state ESTABLISHED -j ACCEPT 

# Open inbound ssh(tcp port 22) connections 

ip6tables -A INPUT -p tcp --dport 22 -m state --state NEW -j ACCEPT

# 3.4.3.3.4 Ensure ip6tables default deny firewall policy

ip6tables -P INPUT DROP

ip6tables -P OUTPUT DROP

ip6tables -P FORWARD DROP

# 3.4.3.3.5 Ensure ip6tables config is saved

service ip6tables save

# 3.4.3.3.6 Ensure ip6tables is enabled and active

if systemctl is-active ip6tables | grep "active" &> /dev/null; then
    echo "ip6tables is activated, continuing..."
else
    echo "Activating ip6tables..."
    systemctl --now enable ip6tables
fi

