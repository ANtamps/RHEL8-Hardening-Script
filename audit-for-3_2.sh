#!/bin/bash

if cat /etc/sysctl.d/60-netipv4_sysctl.conf | grep "net.ipv4.ip_forward = 0" &> /dev/null; then
    echo "IPv4 forwarding is disabled: \033[1;32mOK\033[0m"

    if sysctl net.ipv4.ip_forward | grep "net.ipv4.ip_forward = 0" &> /dev/null; then
        echo "Kernel parameter for ip forwarding set to 0: \033[1;32mOK\033[0m"
    else
        echo "Kernel parameter for ip forwarding not set to 0: \033[1;31mERROR\033[0m"
    fi

     if sysctl net.ipv4.route.flush | grep "net.ipv4.route.flush = 1" &> /dev/null; then
        echo "Kernel parameter for route flush set to 1: \033[1;32mOK\033[0m"
    else
        echo "Kernel parameter for route flush not set to 1: \033[1;31mERROR\033[0m"
    fi
else
    echo "IPv4 forwarding might be enabled: \033[1;31mERROR\033[0m"
fi


# If IPv6 is enabled, uncomment this

# if cat /etc/sysctl.d/60-netipv6_sysctl.conf | grep "net.ipv6.conf.all.forwarding = 0" &> /dev/null; then
#     echo "IPv6 forwarding is disabled: \033[1;32mOK\033[0m"

#     if sysctl net.ipv6.conf.all.forwarding | grep "net.ipv6.conf.all.forwarding = 0" &> /dev/null; then
#         echo "Kernel parameter for ipv6 forwarding set to 0: \033[1;32mOK\033[0m"
#     else
#        echo "Kernel parameter for ip forwarding not set to 0: \033[1;31mERROR\033[0m"
#     fi

#      if sysctl net.ipv6.route.flush | grep "net.ipv6.route.flush = 1" &> /dev/null; then
#         echo "Kernel parameter for route flush set to 1: \033[1;32mOK\033[0m"
#     else
#         echo "Kernel parameter for route flush not set to 1: \033[1;31mERROR\033[0m"
#     fi
# else
#     echo "IPv6 forwarding might be enabled: \033[1;31mERROR\033[0m"
# fi

if cat /etc/sysctl.d/60-netipv4_syctl.conf | grep "net.ipv4.conf.all.send_redirects = 0" &> /dev/null; then
    echo "Packet redirecting all set to 0: \033[1;32mOK\033[0m"

    if sysctl net.ipv4.conf.all.send_redirects | grep "net.ipv4.conf.all.send_redirects = 0" &> /dev/null; then
        echo "Packet redirecting all set to 0 in kernel parameters: \033[1;32mOK\033[0m"
    else
        echo "Kernel parameter not set for packet redirecting: \033[1;31mERROR\033[0m"
    fi
else
    echo "Packet redirecting might not be set to 0: \033[1;31mERROR\033[0m"
fi

if cat /etc/sysctl.d/60-netipv4_syctl.conf | grep "net.ipv4.conf.default.send_redirects = 0" &> /dev/null; then
    echo "Packet redirecting default set to 0: \033[1;32mOK\033[0m"

    if sysctl net.ipv4.conf.default.send_redirects | grep "net.ipv4.conf.default.send_redirects = 0" &> /dev/null; then
        echo "Packet redirecting default set to 0 in kernel parameters: \033[1;32mOK\033[0m"
    else
        echo "Kernel parameter not set for packet redirecting: \033[1;31mERROR\033[0m"
    fi
else
    echo "Default redirect might not be set to 0: \033[1;31mERROR\033[0m" 
fi