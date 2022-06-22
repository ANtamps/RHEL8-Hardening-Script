#!/bin/bash

if cat /etc/sysctl.d/60-netipv4_sysctl.conf | grep "net.ipv4.ip_forward = 0" &> /dev/null; then
    echo "IPv4 forwarding is disabled, checking in sysctl..."

    if sysctl net.ipv4.ip_forward | grep "net.ipv4.ip_forward = 0" &> /dev/null; then
        echo "Kernel parameter for ip forwarding set to 0, continuing..."
    else
        echo "Setting kernel parameter of ipv4 forwarding to 0..."
        sysctl -w net.ipv4.ip_forward=0 &> /dev/null
    fi

     if sysctl net.ipv4.route.flush | grep "net.ipv4.route.flush = 1" &> /dev/null; then
        echo "Kernel parameter for route flush set to 1, continuing..."
    else
        echo "Setting kernel parameter of route flush to 1..."
        sysctl -w net.ipv4.route.flush=1 &> /dev/null
    fi
else
    echo "IPv4 forwarding might be enabled, adding in parameter to conf file..."
    echo "net.ipv4.ip_forward = 0" >> /etc/sysctl.d/60-netipv4_sysctl.conf

    echo "IPv4 forwarding set, checking in sysctl..."

    if sysctl net.ipv4.ip_forward | grep "net.ipv4.ip_forward = 0" &> /dev/null; then
        echo "Kernel parameter for ip forwarding set to 0, continuing..."
    else
        echo "Setting kernel parameter of ipv4 forwarding to 0..."
        sysctl -w net.ipv4.ip_forward=0 &> /dev/null
    fi

     if sysctl net.ipv4.route.flush | grep "net.ipv4.route.flush = 1" &> /dev/null; then
        echo "Kernel parameter for route flush set to 1, continuing..."
    else
        echo "Setting kernel parameter of route flush to 1..."
        sysctl -w net.ipv4.route.flush=1 &> /dev/null
    fi
fi

# IF IPv6 is enabled, uncomment this

# if cat /etc/sysctl.d/60-netipv6_sysctl.conf | grep "net.ipv6.conf.all.forwarding = 0" &> /dev/null; then
#     echo "IPv4 forwarding is disabled, checking in sysctl..."

#     if sysctl net.ipv6.conf.all.forwarding | grep "net.ipv6.conf.all.forwarding = 0" &> /dev/null; then
#         echo "Kernel parameter for ipv6 forwarding set to 0, continuing..."
#     else
#         echo "Setting kernel parameter of ipv6 forwarding to 0..."
#         sysctl -w net.ipv6.conf.all.forwarding=0 &> /dev/null
#     fi

#      if sysctl net.ipv6.route.flush | grep "net.ipv6.route.flush = 1" &> /dev/null; then
#         echo "Kernel parameter for route flush set to 1, continuing..."
#     else
#         echo "Setting kernel parameter of route flush to 1..."
#         sysctl -w net.ipv6.route.flush=1 &> /dev/null
#     fi
# else
#     echo "IPv6 forwarding might be enabled, adding in parameter to conf file..."
#     echo "net.ipv6.conf.all.forwarding" >> /etc/sysctl.d/60-netipv4_sysctl.conf

#     echo "IPv6 forwarding set, checking in sysctl..."

#     if sysctl net.ipv6.conf.all.forwarding | grep "net.ipv6.conf.all.forwarding = 0" &> /dev/null; then
#         echo "Kernel parameter for ipv6 forwarding set to 0, continuing..."
#     else
#         echo "Setting kernel parameter of ipv6 forwarding to 0..."
#         sysctl -w net.ipv6.conf.all.forwarding=0 &> /dev/null
#     fi

#      if sysctl net.ipv6.route.flush | grep "net.ipv6.route.flush = 1" &> /dev/null; then
#         echo "Kernel parameter for route flush set to 1, continuing..."
#     else
#         echo "Setting kernel parameter of route flush to 1..."
#         sysctl -w net.ipv6.route.flush=1 &> /dev/null
#     fi
# fi

if cat /etc/sysctl.d/60-netipv4_syctl.conf | grep "net.ipv4.conf.all.send_redirects = 0" &> /dev/null; then
    echo "Packet redirecting all set to 0, checking in sysctl..."

    if sysctl net.ipv4.conf.all.send_redirects | grep "net.ipv4.conf.all.send_redirects = 0" &> /dev/null; then
        echo "Packet redirecting all set to 0 in kernel parameters, continuing..."
    else
        echo "Kernel parameter not set for packet redirecting, fixing..."
        sysctl -w net.ipv4.conf.all.send_redirects=0 &> /dev/null
    fi
fi

if cat /etc/sysctl.d/60-netipv4_syctl.conf | grep "net.ipv4.conf.default.send_redirects = 0" &> /dev/null; then
    echo "Packet redirecting default set to 0, checking in sysctl..."

    if sysctl net.ipv4.conf.default.send_redirects | grep "net.ipv4.conf.default.send_redirects = 0" &> /dev/null; then
        echo "Packet redirecting default set to 0 in kernel parameters, continuing..."
    else
        echo "Kernel parameter not set for packet redirecting, fixing..."
        sysctl -w net.ipv4.conf.default.send_redirects=0 &> /dev/null
    fi
fi


        
