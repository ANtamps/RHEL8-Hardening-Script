#!/bin/bash

if rpm -q iptables ip tables-services &> /dev/null; then
    echo "iptables installed: \033[1;32mOK\033[0m"
else   
    echo "ip tables not found: \033[1;31mERROR\033[0m"
fi

if rpm -q nftables &> /dev/null; then
    echo "nftables installed: \033[1;32mOK\033[0m"

else
    echo "nftables not installed: \033[1;31mERROR\033[0m"
fi

if rpm -q firewalld &> /dev/null; then
    echo "firewalld installed: \033[1;32mOK\033[0m"
    dnf remove firewalld &> /dev/null
else
    echo "firewalld not installed: \033[1;31mERROR\033[0m"
fi

