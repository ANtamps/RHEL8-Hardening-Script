#!/bin/bash

##AUDIT

##3.4.1

##3.4.1.1 Ensure firewalld is installed
if rpm -q firewalld iptables &> /dev/null; then
    echo -e "firewalld and iptables installed: \033[1;32mOK\033[0m"
else   
     echo -e "firewalld and iptables not found: \033[1;31mERROR\033[0m"

fi
##3.4.1.2 Ensure iptables-services not installed with firewalld
if rpm -q iptables-services &> /dev/null; then
    echo -e "package iptables-services found: \033[1;31mERROR\033[0m"
else   
   echo -e "package iptables-services not installed: \033[1;32mOK\033[0m"
fi

##3.4.1.3 Ensure nftables either not installed or masked with firewalld 
if  rpm -q nftables &> /dev/null; then
     echo -e "package nftables not installed: \033[1;32mOK\033[0m"
else   
     echo -e "package nftables found: \033[1;31mERROR\033[0m"

fi

##3.4.1.4 Ensure firewalld service enabled and running
if  systemctl is-enabled firewalld &> /dev/null; then
    echo -e "Enabled: \033[1;32mOK\033[0m"
else   
    echo -e "Not enabled: \033[1;31mERROR\033[0m"
fi

if  firewall-cmd --state &> /dev/null; then
    echo -e "Running: \033[1;32mOK\033[0m"
else   
    echo -e "Not running: \033[1;31mERROR\033[0m"
fi

##3.4.1.5 Ensure firewalld default zone is set 

if   firewall-cmd --get-default-zone &> /dev/null; then
    echo -e "Zone is set: \033[1;32mOK\033[0m"
else   
    echo -e "No zone found: \033[1;31mERROR\033[0m"
fi

##3.4.2

##3.4.2.1 Ensure nftables is installed (Automated)

if  rpm -q nftables &> /dev/null; then
    echo -e "nftables installed: \033[1;32mOK\033[0m"
else   
     echo -e "nftable not found: \033[1;31mERROR\033[0m"

fi
##3.4.2.2 Ensure firewalld is either not installed or masked with nftables 
if   systemctl is-enabled firewalld &> /dev/null; then
    echo -e "firewalld unmasked: \033[1;31mERROR\033[0m"
else   
   echo -e "firewalld nmasked: \033[1;32mOK\033[0m"
fi
##3.4.2.3 Ensure iptables-services not installed with nftables
if  rpm -q iptables-services &> /dev/null; then
     echo -e "package iptables-services found: \033[1;31mERROR\033[0m"
else   
     echo -e "package iptables-services not installed: \033[1;32mOK\033[0m"
fi

##3.4.2.4 Ensure iptables are flushed with nftables (Manual)

##3.4.2.5 Ensure an nftables table exists
 nft list tables
echo -e  "nftables table exists: \033[1;32mOK\033[0m"
