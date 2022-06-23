#!/bin/bash

##3.4.1 

##3.4.1.1 Ensure firewalld is installed
if rpm -q firewalld iptables &> /dev/null; then
    echo "FirewallD and iptables installed, continuing..."
else   
    echo "ip tables not found, installing..."
    dnf -y install firewalld iptables &> /dev/null
fi
##3.4.1.2 Ensure iptables-services not installed with firewalld

if rpm -q iptables-services &> /dev/null; then
    echo "package iptables-services  found, removing..."
    sudo yum -y install iptables-services
    systemctl stop iptables
    dnf -y remove iptables-services

else   
    echo "Package iptables-services is not installed, continuing..."
fi

##3.4.1.3 Ensure nftables either not installed or masked with firewalld 

if  rpm -q nftables &> /dev/null; then
    echo "nftables installed, removing..."
    dnf -y remove nftables &> /dev/null
else
    echo "nftables not installed, continuing..."
fi

##3.4.1.4 Ensure firewalld service enabled and running
	
if   systemctl is-enabled firewalld &> /dev/null; then
    echo "already enabled, continuing..."
   
else
    echo "firewalld is still masked, enabling..."
	sudo yum -y install firewalld
	systemctl unmask firewalld
fi

if    firewall-cmd --state &> /dev/null; then
    echo "already running, continuing..."
   
else
    echo "firewalld is not running, enabling..."
	systemctl --now enable firewalld
fi
##3.4.1.5 Ensure firewalld default zone is set 
	 firewall-cmd --set-default-zone=public

##3.4.1.6 Ensure network interfaces are assigned to appropriate zone (Manual)
##3.4.1.7 Ensure firewalld drops unnecessary services and ports (Manual)


##3.4.2

##3.4.2.1 Ensure nftables is installed (Automated)

if  rpm -q nftables &> /dev/null; then
    echo "nftables installed, continuing..."
else   
    echo "nftables not found, installing..."
     dnf -y install nftables &> /dev/null
fi

##3.4.2.2 Ensure firewalld is either not installed or masked with nftables 

if rpm -q iptables-services &> /dev/null; then
   echo "Firewalld found.. masking.."
   systemctl --now mask firewalld

else   
    echo "Firewalld is masked, continuing..."
	systemctl --now mask firewalld
fi

##3.4.2.3 Ensure iptables-services not installed with nftables

if  rpm -q iptables-services &> /dev/null; then
    echo "iptables-services installed, removing..."
    dnf -y remove iptables-services &> /dev/null
else
    echo "iptables-services not installed, continuing..."
    dnf -y remove iptables-services
fi

##3.4.2.4 Ensure iptables are flushed with nftables (Manual)

##3.4.2.5 Ensure an nftables table exists
 nft create table inet filter

